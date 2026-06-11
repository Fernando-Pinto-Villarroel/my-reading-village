#!/usr/bin/env python3
"""
CLI dispatcher for My Reading Village marketing content.

Usage:
  python scripts/generate.py --template reading_benefits_story_es
  python scripts/generate.py --template reading_benefits_story_en
  python scripts/generate.py --template villager_spotlight --villager cat --lang en
"""
import argparse, importlib, inspect, sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

TEMPLATES = {
    'reading_benefits_story':    'templates.video.reading_benefits_story',
    'villager_reveal_reel':      'templates.video.villager_reveal_reel',
    'gameplay_showcase':         'templates.video.gameplay_showcase',
    'countdown_story':           'templates.video.countdown_story',
    'villager_spotlight':        'templates.image.villager_spotlight',
    'feature_highlight':         'templates.image.feature_highlight',
    'reading_tip':               'templates.image.reading_tip',
}

LANGS = ['en', 'es', 'pt', 'fr', 'it']


def main():
    parser = argparse.ArgumentParser(
        description='Generate My Reading Village marketing content')
    parser.add_argument('--template', required=True,
                        metavar='TEMPLATE',
                        help=f'One of: {", ".join(TEMPLATES)}')
    parser.add_argument('--villager', default=None,
                        help='Villager name (e.g. cat, rabbit, fox)')
    parser.add_argument('--lang', default='en', choices=LANGS,
                        help=f'Language code ({", ".join(LANGS)})')
    args = parser.parse_args()

    mod = importlib.import_module(TEMPLATES[args.template])

    if hasattr(mod, 'run'):
        params = inspect.signature(mod.run).parameters
        kwargs = {}
        if 'villager' in params:
            kwargs['villager'] = args.villager
        if 'lang' in params:
            kwargs['lang'] = args.lang
        mod.run(**kwargs)
    elif hasattr(mod, 'main'):
        mod.main()
    else:
        print(f'Template "{args.template}" has no run() or main() entry point.')
        sys.exit(1)


if __name__ == '__main__':
    main()
