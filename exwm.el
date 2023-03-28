;;;; Below are configurations for EXWM.

;; Load EXWM and required libraries.
(require 'exwm)
(require 'exwm-config)
(require 'exwm-systemtray)
(require 'exwm-randr)

;; Fix problems with Ido (if you use it).
(exwm-config-ido)

;; Enable system tray.
(exwm-systemtray-enable)

;; Set the initial number of workspaces.
(setq exwm-workspace-number 4)

;; Customize buffer names for EXWM.
(add-hook 'exwm-manage-finish-hook
          (lambda ()
            (when (and exwm-class-name
                       (string= exwm-class-name "Google-chrome"))
              (exwm-input-set-local-simulation-keys nil))))
(add-hook 'exwm-manage-finish-hook
          (lambda ()
            (when (and exwm-class-name
                       (string= exwm-class-name "Firefox"))
              (exwm-input-set-local-simulation-keys nil))))

;; Global keybindings for EXWM.
(setq exwm-input-global-keys
      `(
        ;; Bind "s-r" to exit char-mode and fullscreen mode.
        ([?\s-r] . exwm-reset)

	;; Move between windows
        ([s-left]  . windmove-swap-states-left)
        ([s-right] . windmove-swap-states-right)
        ([s-up]    . windmove-swap-states-up)
        ([s-down]  . windmove-swap-states-down)
	([s-tab]   . windmove-right)
	([s-M-tab] . windmove-left)
        ;; Bind "s-w" to switch workspace interactively.
        ([?\s-w] . exwm-workspace-switch)

        ;; Bind "s-0" to "s-9" to switch to a workspace by its index.
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
			(exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))
        ;; Bind "s-&" to launch applications ('M-&' also works if the output
        ;; buffer does not bother you).

	([?\s-&] . (lambda (command)
		     (interactive (list (read-shell-command "$ ")))
		     (start-process-shell-command command nil command)))

	([?\s-b] . (lambda ()
		     (interactive)
		     (start-process "" nil "google-chrome")))

        ;; Bind "s-<f2>" to "slock", a simple X display locker.
        ([s-f2] . (lambda ()
		    (interactive)
		    (start-process "" nil "/usr/bin/slock")))))

;; Configure line-mode keybinding.
(define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

;; Configure simulation keys for EXWM.
(setq exwm-input-simulation-keys
      '(
        ;; movement
        ([?\C-b] . [left])
        ([?\M-b] . [C-left])
        ([?\C-f] . [right])
        ([?\M-f] . [C-right])
        ([?\C-p] . [up])
        ([?\C-n] . [down])
        ([?\C-a] . [home])
        ([?\C-e] . [end])
        ([?\M-v] . [prior])
        ([?\C-v] . [next])
        ([?\C-d] . [delete])
        ([?\C-k] . [S-end delete])
        ;; cut/paste.
        ([?\C-w] . [?\C-x])
        ([?\M-w] . [?\C-c])
        ([?\C-y] . [?\C-v])
        ;; search
        ([?\C-s] . [?\C-f])))

;; Hide the minibuffer and echo area when not in use.
;; (setq exwm-workspace-minibuffer-position 'bottom)

;; Configure EXWM-RANDR for multiple monitors.
(setq exwm-randr-workspace-monitor-plist '(0 "eDP-1" 1 "DP-3"))
(add-hook 'exwm-randr-screen-change-hook
          (lambda ()
            (start-process-shell-command
             "xrandr" nil "xrandr --output eDP-1 --left-of DP-3 --auto")))
(exwm-randr-enable)

;; Enable EXWM.
(exwm-enable)
