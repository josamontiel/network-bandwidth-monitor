#!/usr/bin/env python3

import argparse
import psutil
import time

def get_bytes_sent_received():
    # Get network statistics from psutil library
    net_stats = psutil.net_io_counters()
    bytes_sent = net_stats.bytes_sent
    bytes_received = net_stats.bytes_recv
    return bytes_sent, bytes_received

def convert_bytes(bytes_val):
    # Helper function to convert bytes to human-readable format (e.g., KB, MB, GB)
    for unit in ['', 'K', 'M', 'G', 'T']:
        if abs(bytes_val) < 1024.0:
            return "%3.1f %sB" % (bytes_val, unit)
        bytes_val /= 1024.0

def monitor_bandwidth(interval=1, duration=60):
    # Monitor network bandwidth for the specified duration at the given interval
    print("Monitoring network bandwidth...")
    end_time = time.time() + duration
    prev_bytes_sent, prev_bytes_received = get_bytes_sent_received()

    while time.time() < end_time:
        time.sleep(interval)

        bytes_sent, bytes_received = get_bytes_sent_received()
        sent_speed = bytes_sent - prev_bytes_sent
        received_speed = bytes_received - prev_bytes_received

        print(f"Sent: {convert_bytes(sent_speed)}/s | Received: {convert_bytes(received_speed)}/s")
        
        prev_bytes_sent = bytes_sent
        prev_bytes_received = bytes_received

def main():
    # Parse command-line arguments and start monitoring
    parser = argparse.ArgumentParser(
        description="Network Bandwidth Monitor",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument(
        "-i", "--interval",
        type=int,
        default=1,
        help="Interval in seconds to check bandwidth (default: 1 second)"
    )
    parser.add_argument(
        "-d", "--duration",
        type=int,
        default=60,
        help="Duration in seconds to monitor the bandwidth (default: 60 seconds)"
    )
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Display documentation and directions on how the app works"
    )
    args = parser.parse_args()

    if args.verbose:
        print("Network Bandwidth Monitor")
        print("------------------------")
        print("This script monitors the network bandwidth usage.")
        print("It calculates and displays the data transfer rate (in bytes per second) for both sent and received data.")
        print("You can specify the monitoring interval and the duration for which you want to monitor the network bandwidth.")
        print("The default interval is 1 second, and the default duration is 60 seconds.")
        print("Usage: python bandwidth_monitor.py [-h] [-v] [-i INTERVAL] [-d DURATION]")
        return

    monitor_bandwidth(interval=args.interval, duration=args.duration)

if __name__ == "__main__":
    main()
