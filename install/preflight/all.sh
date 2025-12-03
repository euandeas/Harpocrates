source $HARPOCRATES_INSTALL/preflight/begin.sh
run_logged $HARPOCRATES_INSTALL/preflight/show-env.sh
run_logged $HARPOCRATES_INSTALL/preflight/pacman.sh
run_logged $HARPOCRATES_INSTALL/preflight/first-run-mode.sh
run_logged $HARPOCRATES_INSTALL/preflight/disable-mkinitcpio.sh
