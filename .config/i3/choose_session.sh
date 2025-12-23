#!/bin/bash
echo "Select your session:"
echo "1) Pop!_OS (GNOME/Pop Shell)"
echo "2) i3"
read -p "Enter choice [1 or 2]: " choice
case "$choice" in
    1)
        # Launch Pop!_OS session (adjust if needed)
        exec dbus-launch --exit-with-session gnome-session --session=pop-os
        ;;
    2)
        exec i3
        ;;
    *)
        echo "Invalid choice. Defaulting to i3."
        exec i3
        ;;
esac

