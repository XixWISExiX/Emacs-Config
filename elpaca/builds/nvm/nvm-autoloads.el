;;; nvm-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "nvm" "nvm.el" (0 0 0 0))
;;; Generated autoloads from nvm.el

(autoload 'nvm-use "nvm" "\
Activate Node VERSION.

If CALLBACK is specified, active in that scope and then reset to
previously used version.

\(fn VERSION &optional CALLBACK)" t nil)

(autoload 'nvm-use-for "nvm" "\
Activate Node for PATH or `default-directory'.

This function will look for a .nvmrc file in that path and
activate the version specified in that file.

If CALLBACK is specified, active in that scope and then reset to
previously used version.

\(fn &optional PATH CALLBACK)" nil nil)

(autoload 'nvm-use-for-buffer "nvm" "\
Activate Node based on an .nvmrc for the current file.
If buffer is not visiting a file, do nothing." nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "nvm" '("nvm-")))

;;;***

(provide 'nvm-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; nvm-autoloads.el ends here
