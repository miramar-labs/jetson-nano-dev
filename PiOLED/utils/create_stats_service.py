import argparse
import getpass
import os

STATS_SERVICE_TEMPLATE = """
[Unit]
Description=PiOLED stats display service

[Service]
Type=simple
User=%s
ExecStart=/bin/sh -c "python3 /%s/jetson-nano-dev/PiOLED/pioled/stats.py"
WorkingDirectory=%s
Restart=always

[Install]
WantedBy=multi-user.target
"""

STATS_SERVICE_NAME = 'pioled_stats'


def get_stats_service():
    u = getpass.getuser()
    h = os.environ['HOME']
    return STATS_SERVICE_TEMPLATE % (u,h,h)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', default='pioled_stats.service')
    args = parser.parse_args()

    with open(args.output, 'w') as f:
        f.write(get_stats_service())
