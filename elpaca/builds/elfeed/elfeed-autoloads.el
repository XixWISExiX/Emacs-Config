;;; elfeed-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:


;;;### (autoloads nil "elfeed" "elfeed.el" (0 0 0 0))
;;; Generated autoloads from elfeed.el

(autoload 'elfeed-update "elfeed" "\
Update all the feeds in `elfeed-feeds'." t nil)

(autoload 'elfeed "elfeed" "\
Enter elfeed." t nil)

(autoload 'elfeed-load-opml "elfeed" "\
Load feeds from an OPML file into `elfeed-feeds'.
When called interactively, the changes to `elfeed-feeds' are
saved to your customization file.

\(fn FILE)" t nil)

(autoload 'elfeed-export-opml "elfeed" "\
Export the current feed listing to OPML-formatted FILE.

\(fn FILE)" t nil)

(register-definition-prefixes "elfeed" '("elfeed-"))

;;;***

;;;### (autoloads nil "elfeed-csv" "elfeed-csv.el" (0 0 0 0))
;;; Generated autoloads from elfeed-csv.el

(register-definition-prefixes "elfeed-csv" '("elfeed-csv-"))

;;;***

;;;### (autoloads nil "elfeed-curl" "elfeed-curl.el" (0 0 0 0))
;;; Generated autoloads from elfeed-curl.el

(register-definition-prefixes "elfeed-curl" '("elfeed-curl-"))

;;;***

;;;### (autoloads nil "elfeed-db" "elfeed-db.el" (0 0 0 0))
;;; Generated autoloads from elfeed-db.el

(register-definition-prefixes "elfeed-db" '("elfeed-" "with-elfeed-db-visit"))

;;;***

;;;### (autoloads nil "elfeed-lib" "elfeed-lib.el" (0 0 0 0))
;;; Generated autoloads from elfeed-lib.el

(register-definition-prefixes "elfeed-lib" '("elfeed-"))

;;;***

;;;### (autoloads nil "elfeed-link" "elfeed-link.el" (0 0 0 0))
;;; Generated autoloads from elfeed-link.el

(autoload 'elfeed-link-store-link "elfeed-link" "\
Store a link to an elfeed search or entry buffer.

When storing a link to an entry, automatically extract all the
entry metadata. These can be used in the capture templates as
`%:keyword` expansion.

List of available keywords, when store from an Elfeed search:
- `type`        : Type of Org-mode link
- `link`        : Org-mode link to this search, also available
                  with %a, %A, %l and %L
- `description` : The search filter


List of available keywords, when store from an Elfeed entry:
- `type`                    : Type of Org-mode link
- `link`                    : Org-mode link to this entry, also available
                              with %a, %A, %l and %L
- `title`                   : Feed entry title
- `description`             : Feed entry description, same as title
- `external-link`           : Feed entry external link
- `date`                    : Date time of the feed entry publication, in
                              full ISO 8601 format
- `date-timestamp`          : Date time of the feed entry publication, in
                              Org-mode active timestamp format
- `date-inactive-timestamp` : Date time of the feed entry publication, in
                              Org-mode inactive timestamp format
- `authors`                 : List of feed entry authors names, joint by a
                              comma
- `tags`                    : List of feed entry tags, in Org-mode tags
                              format
- `content`                 : Content of the feed entry
- `feed-title`              : Title of the feed
- `feed-external-link`      : Feed external link
- `feed-authors`            : List of feed authors names, joint by a comma

If `content` type is HTML, it is automatically embedded into an
Org-mode HTML quote." nil nil)

(autoload 'elfeed-link-open "elfeed-link" "\
Jump to an elfeed entry or search.

Depending on what FILTER-OR-ID looks like, we jump to either
search buffer or show a concrete entry.

\(fn FILTER-OR-ID)" nil nil)

(eval-after-load 'org `(funcall ',(lambda nil (if (version< (org-version) "9.0") (with-no-warnings (org-add-link-type "elfeed" #'elfeed-link-open) (add-hook 'org-store-link-functions #'elfeed-link-store-link)) (with-no-warnings (org-link-set-parameters "elfeed" :follow #'elfeed-link-open :store #'elfeed-link-store-link))))))

;;;***

;;;### (autoloads nil "elfeed-log" "elfeed-log.el" (0 0 0 0))
;;; Generated autoloads from elfeed-log.el

(register-definition-prefixes "elfeed-log" '("elfeed-log"))

;;;***

;;;### (autoloads nil "elfeed-search" "elfeed-search.el" (0 0 0 0))
;;; Generated autoloads from elfeed-search.el

(autoload 'elfeed-search-bookmark-handler "elfeed-search" "\
Jump to an elfeed-search bookmarked location.

\(fn RECORD)" nil nil)

(autoload 'elfeed-search-desktop-restore "elfeed-search" "\
Restore the state of an elfeed-search buffer on desktop restore.

\(fn FILE-NAME BUFFER-NAME SEARCH-FILTER)" nil nil)

(add-to-list 'desktop-buffer-mode-handlers '(elfeed-search-mode . elfeed-search-desktop-restore))

(register-definition-prefixes "elfeed-search" '("elfeed-s"))

;;;***

;;;### (autoloads nil "elfeed-show" "elfeed-show.el" (0 0 0 0))
;;; Generated autoloads from elfeed-show.el

(autoload 'elfeed-show-bookmark-handler "elfeed-show" "\
Show the bookmarked entry saved in the `RECORD'.

\(fn RECORD)" nil nil)

(register-definition-prefixes "elfeed-show" '("elfeed-"))

;;;***

;;;### (autoloads nil "xml-query" "xml-query.el" (0 0 0 0))
;;; Generated autoloads from xml-query.el

(register-definition-prefixes "xml-query" '("xml-query"))

;;;***

(provide 'elfeed-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; elfeed-autoloads.el ends here
