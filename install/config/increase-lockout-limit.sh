# Increase lockout limit to 5 and decrease timeout to 3 minutes
sudo sed -i 's|^\(auth\s\+required\s\+pam_faillock.so\)\s\+preauth.*$|\1 preauth silent deny=5 unlock_time=180|' "/etc/pam.d/system-auth"
sudo sed -i 's|^\(auth\s\+\[default=die\]\s\+pam_faillock.so\)\s\+authfail.*$|\1 authfail deny=5 unlock_time=180|' "/etc/pam.d/system-auth"
