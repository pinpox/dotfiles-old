# -*- coding: utf-8 -*-

import subprocess

from i3pystatus import Status
from i3pystatus.mail import notmuchmail
from i3pystatus.weather import weathercom

status = Status(standalone=True)
color_white="#f8f8f2"
color_green="#a6e22e"
color_yellow="#fd971f"
color_red="#f92672"



h = {"separator": False, "separator_block_width": 5, "markup": 'pango'}


creds = '/home/binaryplease/.credentials/calendar-python-quickstart.json'


#Date
status.register("clock",
        format="  %a %-d %b %H:%M:%S",hints=h)
# Calendar
status.register("google_calendar", credential_path=creds, format="  <span color=\"#66d9ef\"></span> {summary} ({remaining_time})", hints = h)

#CPU Temperature
status.register("temp",format="  <span color=\"#66d9ef\"></span> {temp}°C",file="/sys/class/thermal/thermal_zone1/temp", hints = h)

#status.register("cpu_usage",format="  <span color=\"#66d9ef\"></span>{usage_cpu0:3.0f}%{usage_cpu1:3.0f}%{usage_cpu2:3.0f}%{usage_cpu3:3.0f}%{usage_cpu4:3.0f}%{usage_cpu5:3.0f}%{usage_cpu6:3.0f}%{usage_cpu7:3.0f}%",hints=h)

status.register("cpu_usage_graph",graph_style='braille-fill', hints=h, format=" {cpu_graph}")

#RAM
status.register("mem",format="  <span color=\"#66d9ef\"></span>  {percent_used_mem}%",hints=h,
        color=color_green,
        warn_color=color_yellow,
        alert_color=color_red
        )

#Battery
status.register("battery",
        battery_ident="BAT1",
        format="{status} {percentage:.2f}% {remaining:%E%hh:%Mm}",
        alert=True,
        alert_percentage=5,
        hints=h,
        full_color=color_green,
        critical_color=color_red,
        status={
            "DIS": "  <span color=\"#66d9ef\"></span>",
            "CHR": "  <span color=\"#66d9ef\"></span>",
            "FULL": "  <span color=\"#66d9ef\"></span>",
            },)

status.register("network",
        interface="enp0s20u3u4",
        hints=h,
        start_color=color_white,
        end_color=color_red,
        format_up="  <span color=\"#66d9ef\"></span> {v4} {bytes_recv:04.0f}kbs",
        format_down="")

status.register("network",
        interface="wlp4s0",
        hints=h,
        start_color=color_white,
        end_color=color_red,
        format_up="  <span color=\"#66d9ef\"></span> {essid} {quality:03.0f}% {v4} {bytes_recv:04.0f}kbs",
        format_down="")

#Disk
status.register("disk",
        hints=h,
        path="/",
        format="  <span color=\"#66d9ef\"></span> {percentage_used}% [{avail}G]",)

#spotify
status.register("spotify",format_not_running="",format="{status} {artist} - {title}", status={'paused': '  <span color=\"#66d9ef\"></span>', 'playing': '  <span color=\"#66d9ef\"></span>'}, hints=h)

#Audio
#status.register("alsa",
        #format="  <span color=\"#66d9ef\"></span> {volume}",format_muted="  <span color=\"#66d9ef\"></span> MUTE", hints=h)

#Backlight
status.register("backlight",
        format="  <span color=\"#66d9ef\">☀</span> {percentage}",hints=h,
        base_path="/sys/class/backlight/acpi_video0/")

#Mail
status.register("mail",
        backends=[ notmuchmail.Notmuch()
            ],
        hide_if_null=True,
        hints=h,
        format="  <span color=\"#66d9ef\"></span> {unread}",
        format_plural="  <span color=\"#66d9ef\"></span> {unread}")

#Weather
status.register(
        'weather',
        #format='{condition} {current_temp}{temp_unit}{icon}[ Hi: {high_temp}] Lo: {low_temp}',
        format="{condition} {current_temp}{temp_unit} - {humidity}%",
        hints=h,
        colorize=True,
        backend=weathercom.Weathercom(
            location_code="GMXX5686",
            ),
        )
status.run()
