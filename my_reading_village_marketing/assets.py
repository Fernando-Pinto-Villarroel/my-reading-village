import os

_HERE      = os.path.dirname(os.path.abspath(__file__))
_ROOT      = os.path.abspath(os.path.join(_HERE, '..'))
ASSETS_DIR = os.path.join(_ROOT, 'my_reading_village/assets')
OUTPUT_DIR = os.path.join(_HERE, 'output')

def asset(rel: str) -> str:
    return os.path.join(ASSETS_DIR, rel)
