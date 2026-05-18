import argparse
import sys
from pathlib import Path

from PIL import Image


SUPPORTED_EXTENSIONS = {".png", ".jpg", ".jpeg", ".bmp", ".webp", ".tiff"}


def mirror_image(image: Image.Image, direction: str) -> Image.Image:
    if direction == "horizontal":
        return image.transpose(Image.FLIP_LEFT_RIGHT)
    return image.transpose(Image.FLIP_TOP_BOTTOM)


def process_batch(input_dir: Path, output_dir: Path, direction: str) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)

    image_files = sorted(
        f for f in input_dir.iterdir()
        if f.is_file() and f.name != ".gitkeep" and f.suffix.lower() in SUPPORTED_EXTENSIONS
    )

    if not image_files:
        print(f"No images found in {input_dir}")
        return

    print(f"Found {len(image_files)} image(s) in {input_dir}")
    print(f"Direction: {direction}")
    print(f"Output directory: {output_dir}")
    print()

    for filepath in image_files:
        stem = filepath.stem
        output_path = output_dir / f"{stem}.png"

        try:
            image = Image.open(filepath)
            original_mode = image.mode
            result = mirror_image(image, direction)
            result.save(output_path, "PNG")
            print(f"  [OK] {filepath.name} -> {output_path.name}  "
                  f"({image.size[0]}x{image.size[1]}, mode: {original_mode}, direction: {direction})")
        except Exception as e:
            print(f"  [FAIL] {filepath.name}: {e}")

    print()
    print("Done.")


def main() -> None:
    parser = argparse.ArgumentParser(
        description=(
            "Mirror images horizontally or vertically.\n"
            "Preserves original size, content, transparency, and format."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    direction_group = parser.add_mutually_exclusive_group(required=True)
    direction_group.add_argument(
        "--horizontal",
        action="store_true",
        help="Mirror the image horizontally (flip left-right)",
    )
    direction_group.add_argument(
        "--vertical",
        action="store_true",
        help="Mirror the image vertically (flip top-bottom)",
    )

    parser.add_argument(
        "-i", "--input",
        default=None,
        help="Input directory. Default: tools/images-to-mirror/",
    )
    parser.add_argument(
        "-o", "--output",
        default=None,
        help="Output directory. Default: <input>/output/",
    )

    args = parser.parse_args()

    direction = "horizontal" if args.horizontal else "vertical"

    script_dir = Path(__file__).parent
    input_dir = Path(args.input) if args.input else script_dir / "images-to-mirror"
    output_dir = Path(args.output) if args.output else input_dir / "output"

    if not input_dir.exists():
        print(f"Error: Input directory does not exist: {input_dir}", file=sys.stderr)
        sys.exit(1)

    process_batch(input_dir, output_dir, direction)


if __name__ == "__main__":
    main()
