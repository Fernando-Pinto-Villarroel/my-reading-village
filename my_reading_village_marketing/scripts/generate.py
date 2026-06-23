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
    'reading_challenge_story':   'templates.video.reading_challenge_story',
    'villager_reveal_reel':      'templates.video.villager_reveal_reel',
    'gameplay_showcase':         'templates.video.gameplay_showcase',
    'countdown_story':           'templates.video.countdown_story',
    'villager_spotlight':        'templates.image.villager_spotlight',
    'feature_highlight':         'templates.image.feature_highlight',
    'reading_tip':               'templates.image.reading_tip',
    'excuses_not_to_read':       'templates.image.excuses_not_to_read',
    'who_should_read':           'templates.image.who_should_read',
    'what_if_reading':           'templates.image.what_if_reading',
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
    parser.add_argument('--background', type=int, default=None, metavar='N',
                        choices=range(1, 7),
                        help='Splash background number 1-6 (default: template default)')
    parser.add_argument('--fact', type=int, default=None, metavar='N',
                        help='Fact index for feature_highlight (0-based, default: 0)')
    parser.add_argument('--tip', type=int, default=None, metavar='N',
                        help='Tip index for reading_tip (0-based, default: 0)')
    args = parser.parse_args()

    mod = importlib.import_module(TEMPLATES[args.template])

    if hasattr(mod, 'run'):
        params = inspect.signature(mod.run).parameters
        kwargs = {}
        if 'villager' in params:
            kwargs['villager'] = args.villager
        if 'lang' in params:
            kwargs['lang'] = args.lang
        if 'bg' in params and args.background is not None:
            kwargs['bg'] = args.background
        if 'fact' in params and args.fact is not None:
            kwargs['fact'] = args.fact
        if 'tip' in params and args.tip is not None:
            kwargs['tip'] = args.tip
        mod.run(**kwargs)
    elif hasattr(mod, 'main'):
        mod.main()
    else:
        print(f'Template "{args.template}" has no run() or main() entry point.')
        sys.exit(1)


if __name__ == '__main__':
    main()
