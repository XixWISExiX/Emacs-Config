;;; perspective-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "perspective" "perspective.el" (0 0 0 0))
;;; Generated autoloads from perspective.el

(defvar persp-mode nil "\
Non-nil if Persp mode is enabled.
See the `persp-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `persp-mode'.")

(custom-autoload 'persp-mode "perspective" nil)

(autoload 'persp-mode "perspective" "\
Toggle perspective mode.
When active, keeps track of multiple 'perspectives',
named collections of buffers and window configurations.

This is a minor mode.  If called interactively, toggle the `Persp
mode' mode.  If the prefix argument is positive, enable the mode,
and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `(default-value \\='persp-mode)'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'persp-switch-to-buffer* "perspective" "\
Like `switch-to-buffer', restricted to the current perspective.
This respects ido-ignore-buffers, since we automatically add
buffer filtering to ido-mode already (see use of
PERSP-SET-IDO-BUFFERS).

\(fn BUFFER-OR-NAME)" t nil)

(autoload 'persp-kill-buffer* "perspective" "\
Like `kill-buffer', restricted to the current perspective.
This respects ido-ignore-buffers, since we automatically add
buffer filtering to ido-mode already (see use of
PERSP-SET-IDO-BUFFERS).

\(fn BUFFER-OR-NAME)" t nil)

(autoload 'persp-kill-other-buffers "perspective" "\
Kill all buffers in the current perspective other than the current one.
Also excludes the perspective's scratch buffer." t nil)

(autoload 'persp-buffer-menu "perspective" "\
Like the default C-x C-b, but filters for the current perspective's buffers.

\(fn ARG)" t nil)

(autoload 'persp-list-buffers "perspective" "\
Like the default C-x C-b, but filters for the current perspective's buffers.

\(fn ARG)" t nil)

(autoload 'persp-bs-show "perspective" "\
Invoke BS-SHOW with a configuration enabled for Perspective.
With a prefix arg, show buffers in all perspectives.
This respects ido-ignore-buffers, since we automatically add
buffer filtering to ido-mode already (see use of
PERSP-SET-IDO-BUFFERS).

\(fn ARG)" t nil)

(autoload 'persp-ibuffer "perspective" "\
Invoke IBUFFER with a configuration enabled for Perspective.
With a prefix arg, show buffers in all perspectives.
This respects ido-ignore-buffers, since we automatically add
buffer filtering to ido-mode already (see use of
PERSP-SET-IDO-BUFFERS).

\(fn ARG)" t nil)

(autoload 'persp-ivy-switch-buffer "perspective" "\
A version of `ivy-switch-buffer' which respects perspectives.

\(fn ARG)" t nil)

(autoload 'persp-counsel-switch-buffer "perspective" "\
A version of `counsel-switch-buffer' which respects perspectives.

\(fn ARG)" t nil)

(autoload 'persp-state-save "perspective" "\
Save the current perspective state to FILE.

FILE defaults to the value of persp-state-default-file if it is
set.

Each perspective's buffer list and window layout will be saved.
Frames and their associated perspectives will also be saved,
but not the original frame sizes.

Buffers with * characters in their names, as well as buffers without
associated files will be ignored. If such buffers are currently
visible in a perspective as windows, they will be saved as
'*scratch* (persp)' buffers.

\(fn &optional FILE INTERACTIVE\\=\\?)" t nil)

(autoload 'persp-state-load "perspective" "\
Restore the perspective state saved in FILE.

FILE defaults to the value of persp-state-default-file if it is
set.

Frames are restored, along with each frame's perspective list and merge list.
Each perspective's buffer list and window layout are also
restored.

\(fn FILE)" t nil)

(autoload 'persp-ibuffer-generate-filter-groups "perspective" "\
Create a set of ibuffer filter groups based on the persp name of buffers." nil nil)

(autoload 'persp-ibuffer-set-filter-groups "perspective" "\
Set the current filter groups to filter by persp name." t nil)

(register-definition-prefixes "perspective" '("check-persp" "make-persp" "persp" "quick-perspective-keys" "with-"))

;;;***

(provide 'perspective-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; perspective-autoloads.el ends here
