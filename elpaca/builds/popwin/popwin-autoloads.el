;;; popwin-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "popwin" "popwin.el" (0 0 0 0))
;;; Generated autoloads from popwin.el

(autoload 'popwin:popup-buffer "popwin" "\
Show BUFFER in a popup window and return the popup window. If
NOSELECT is non-nil, the popup window will not be selected. If
STICK is non-nil, the popup window will be stuck. If TAIL is
non-nil, the popup window will show the last contents. Calling
`popwin:popup-buffer' during `popwin:popup-buffer' is allowed. In
that case, the buffer of the popup window will be replaced with
BUFFER.

\(fn BUFFER &key (WIDTH popwin:popup-window-width) (HEIGHT popwin:popup-window-height) (POSITION popwin:popup-window-position) NOSELECT DEDICATED STICK TAIL)" t nil)

(autoload 'popwin:display-buffer "popwin" "\
Display BUFFER-OR-NAME, if possible, in a popup window, or as usual.
This function can be used as a value of
`display-buffer-function'.

\(fn BUFFER-OR-NAME &optional NOT-THIS-WINDOW)" t nil)

(autoload 'popwin:pop-to-buffer "popwin" "\
Same as `pop-to-buffer' except that this function will use `popwin:display-buffer-1' instead of `display-buffer'.  BUFFER,
OTHER-WINDOW amd NORECORD are the same arguments.

\(fn BUFFER &optional OTHER-WINDOW NORECORD)" t nil)

(autoload 'popwin:universal-display "popwin" "\
Call the following command interactively with letting `popwin:special-display-config' be `popwin:universal-display-config'.
This will be useful when displaying buffers in popup windows temporarily." t nil)

(autoload 'popwin:one-window "popwin" "\
Delete other window than the popup window. C-g restores the original window configuration." t nil)

(autoload 'popwin:popup-buffer-tail "popwin" "\
Same as `popwin:popup-buffer' except that the buffer will be `recenter'ed at the bottom.

\(fn &rest SAME-AS-POPWIN:POPUP-BUFFER)" t nil)

(autoload 'popwin:find-file "popwin" "\
Edit file FILENAME with popup window by `popwin:popup-buffer'.

\(fn FILENAME &optional WILDCARDS)" t nil)

(autoload 'popwin:find-file-tail "popwin" "\
Edit file FILENAME with popup window by `popwin:popup-buffer-tail'.

\(fn FILE &optional WILDCARD)" t nil)

(autoload 'popwin:messages "popwin" "\
Display *Messages* buffer in a popup window." t nil)

(defvar popwin-mode nil "\
Non-nil if Popwin mode is enabled.
See the `popwin-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `popwin-mode'.")

(custom-autoload 'popwin-mode "popwin" nil)

(autoload 'popwin-mode "popwin" "\
Minor mode for `popwin-mode'.

This is a minor mode.  If called interactively, toggle the
`Popwin mode' mode.  If the prefix argument is positive, enable
the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='popwin-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "popwin" '("popwin:"))

;;;***

(provide 'popwin-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; popwin-autoloads.el ends here
