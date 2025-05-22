;;; org-markdown-preview-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "org-markdown-preview" "org-markdown-preview.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from org-markdown-preview.el

(autoload 'org-markdown-preview-browse-preview "org-markdown-preview" "\
Visit a served page in a browser.
Uses `browse-url' to launch a browser" t nil)

(autoload 'org-markdown-preview-websocket-send-html "org-markdown-preview" "\
Write org content to markdown file and refresh websocket clients.
Org content is taken from `org-markdown-preview-preview-buffer'." t nil)

(autoload 'org-markdown-preview-websocket-send-ghub-html "org-markdown-preview" "\
Send the refreshed Markdown content to the client via WebSocket." t nil)

(autoload 'org-markdown-preview-copy-markdown-as-org "org-markdown-preview" "\
Copy the selected Markdown region as `org-mode' content." t nil)

(autoload 'org-markdown-preview-copy-org-as-markdown "org-markdown-preview" "\
Copy the selected `org-mode' region as Markdown content." t nil)

(autoload 'org-markdown-preview-markdown-write "org-markdown-preview" "\
Write markdown content to a file if conditions are met." t nil)

(autoload 'org-markdown-preview-mode "org-markdown-preview" "\
Preview `Org-mode' content as `GitHub-Flavored' Markdown in a web browser.

This is a minor mode.  If called interactively, toggle the
`Org-Markdown-Preview mode' mode.  If the prefix argument is
positive, enable the mode, and if it is zero or negative, disable
the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `org-markdown-preview-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

Enable `org-markdown-preview-mode' to preview Org files in a web browser as
GitHub Flavored Markdown (GFM). This mode uses a local HTTP server and
WebSockets to provide live updates to the preview as the Org file is edited.

When the mode is enabled, it starts an HTTP server, opens the default web
browser to display the preview, and sets up hooks to update the preview and
scroll position in response to changes in the Org file. The preview is generated
using Pandoc, with options customizable via
`org-markdown-preview-pandoc-options'.

The mode also provides several customization options, including
`org-markdown-preview-pandoc-output-type' to specify the output type for Pandoc,
`org-markdown-preview-scroll-delay' to set the delay before updating the scroll
position, `org-markdown-preview-pandoc-options' to specify extra options for
Pandoc, `org-markdown-preview-refresh-behavior' to control when to refresh the
preview page, `org-markdown-preview-refresh-delay' to set the delay before
refreshing the content, `org-markdown-preview-browse-fn' to specify the function
for browsing the preview page, and `org-markdown-preview-websocket-port' to set
the WebSocket port.

When the mode is disabled, it stops the HTTP server, closes the WebSocket
connections, and removes the hooks it has set up.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "org-markdown-preview" '("org-markdown-preview"))

;;;***

(provide 'org-markdown-preview-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; org-markdown-preview-autoloads.el ends here
