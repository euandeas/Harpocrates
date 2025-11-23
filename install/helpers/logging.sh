start_log_output() {
  local ANSI_SAVE_CURSOR="\033[s"
  local ANSI_RESTORE_CURSOR="\033[u"
  local ANSI_CLEAR_LINE="\033[2K"
  local ANSI_HIDE_CURSOR="\033[?25l"
  local ANSI_RESET="\033[0m"
  local ANSI_GRAY="\033[90m"

  # Save cursor position and hide cursor
  printf $ANSI_SAVE_CURSOR
  printf $ANSI_HIDE_CURSOR

  (
    local log_lines=20
    local max_line_width=$((LOGO_WIDTH - 4))

    while true; do
      # Read the last N lines into an array
      mapfile -t current_lines < <(tail -n $log_lines "$HARPOCRATES_INSTALL_LOG_FILE" 2>/dev/null)

      # Build complete output buffer with escape sequences
      output=""
      for ((i = 0; i < log_lines; i++)); do
        line="${current_lines[i]:-}"

        # Truncate if needed
        if [ ${#line} -gt $max_line_width ]; then
          line="${line:0:$max_line_width}..."
        fi

        # Add clear line escape and formatted output for each line
        if [ -n "$line" ]; then
          output+="${ANSI_CLEAR_LINE}${ANSI_GRAY}${PADDING_LEFT_SPACES}  → ${line}${ANSI_RESET}\n"
        else
          output+="${ANSI_CLEAR_LINE}${PADDING_LEFT_SPACES}\n"
        fi
      done

      printf "${ANSI_RESTORE_CURSOR}%b" "$output"

      sleep 0.1
    done
  ) &
  monitor_pid=$!
}

stop_log_output() {
  if [ -n "${monitor_pid:-}" ]; then
    kill $monitor_pid 2>/dev/null || true
    wait $monitor_pid 2>/dev/null || true
    unset monitor_pid
  fi
}

start_install_log() {
  sudo touch "$HARPOCRATES_INSTALL_LOG_FILE"
  sudo chmod 666 "$HARPOCRATES_INSTALL_LOG_FILE"

  export HARPOCRATES_START_TIME=$(date '+%Y-%m-%d %H:%M:%S')

  echo "=== Harpocrates Installation Started: $HARPOCRATES_START_TIME ===" >>"$HARPOCRATES_INSTALL_LOG_FILE"
  start_log_output
}

stop_install_log() {
  stop_log_output
  show_cursor

  if [[ -n ${HARPOCRATES_INSTALL_LOG_FILE:-} ]]; then
    HARPOCRATES_END_TIME=$(date '+%Y-%m-%d %H:%M:%S')
    echo "=== Harpocrates Installation Completed: $HARPOCRATES_END_TIME ===" >>"$HARPOCRATES_INSTALL_LOG_FILE"
    echo "" >>"$HARPOCRATES_INSTALL_LOG_FILE"
    echo "=== Installation Time Summary ===" >>"$HARPOCRATES_INSTALL_LOG_FILE"

    if [ -f "/var/log/archinstall/install.log" ]; then
      ARCHINSTALL_START=$(grep -m1 '^\[' /var/log/archinstall/install.log 2>/dev/null | sed 's/^\[\([^]]*\)\].*/\1/' || true)
      ARCHINSTALL_END=$(grep 'Installation completed without any errors' /var/log/archinstall/install.log 2>/dev/null | sed 's/^\[\([^]]*\)\].*/\1/' || true)

      if [ -n "$ARCHINSTALL_START" ] && [ -n "$ARCHINSTALL_END" ]; then
        ARCH_START_EPOCH=$(date -d "$ARCHINSTALL_START" +%s)
        ARCH_END_EPOCH=$(date -d "$ARCHINSTALL_END" +%s)
        ARCH_DURATION=$((ARCH_END_EPOCH - ARCH_START_EPOCH))

        ARCH_MINS=$((ARCH_DURATION / 60))
        ARCH_SECS=$((ARCH_DURATION % 60))

        echo "Archinstall: ${ARCH_MINS}m ${ARCH_SECS}s" >>"$HARPOCRATES_INSTALL_LOG_FILE"
      fi
    fi

    if [ -n "$HARPOCRATES_START_TIME" ]; then
      HARPOCRATES_START_EPOCH=$(date -d "$HARPOCRATES_START_TIME" +%s)
      HARPOCRATES_END_EPOCH=$(date -d "$HARPOCRATES_END_TIME" +%s)
      HARPOCRATES_DURATION=$((HARPOCRATES_END_EPOCH - HARPOCRATES_START_EPOCH))

      HARPOCRATES_MINS=$((HARPOCRATES_DURATION / 60))
      HARPOCRATES_SECS=$((HARPOCRATES_DURATION % 60))

      echo "Harpocrates:     ${HARPOCRATES_MINS}m ${HARPOCRATES_SECS}s" >>"$HARPOCRATES_INSTALL_LOG_FILE"

      if [ -n "$ARCH_DURATION" ]; then
        TOTAL_DURATION=$((ARCH_DURATION + HARPOCRATES_DURATION))
        TOTAL_MINS=$((TOTAL_DURATION / 60))
        TOTAL_SECS=$((TOTAL_DURATION % 60))
        echo "Total:       ${TOTAL_MINS}m ${TOTAL_SECS}s" >>"$HARPOCRATES_INSTALL_LOG_FILE"
      fi
    fi
    echo "=================================" >>"$HARPOCRATES_INSTALL_LOG_FILE"

    echo "Rebooting system..." >>"$HARPOCRATES_INSTALL_LOG_FILE"
  fi
}

run_logged() {
  local script="$1"

  export CURRENT_SCRIPT="$script"

  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script" >>"$HARPOCRATES_INSTALL_LOG_FILE"

  # Use bash -c to create a clean subshell
  bash -c "source '$script'" </dev/null >>"$HARPOCRATES_INSTALL_LOG_FILE" 2>&1

  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script" >>"$HARPOCRATES_INSTALL_LOG_FILE"
    unset CURRENT_SCRIPT
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)" >>"$HARPOCRATES_INSTALL_LOG_FILE"
  fi

  return $exit_code
}
