(in-package agar)

(def-suite layout :description "Layout Building Language")

(in-suite layout)

(test expand-widget-label
  "Check whether label is correctly expanded into a let-binding"
  (is (equalp '((my-label (label-new-string *parent* "Text")))
	      (expand-widget '*parent* '(label my-label "Text")))))
	      
(test expand-single-label
  "expand-widgets succeeds for a single label"
  (is (equalp '(let* ((my-label (label-new-string *parent* "Text")))
		(body))
	      (expand-widgets '((label my-label "Text")) '*parent* '((body))))))

(test expand-vbox-with-labels
  "expand-widgets succeeds for a vbox with two labels inside"
  (is (equalp `(let* ((the-vbox (vbox-new *parent* :some-flag :some-other-flag))
		      (lb1 (label-new-string the-vbox "Label 1" :label1-flag1 :label1-flag2))
		      (lb2 (label-new-string the-vbox "Label 2" :label2-flag)))
		 (list vbox lb1 lb2))
	      (expand-widgets (list `(vbox the-vbox (:some-flag :some-other-flag)
					(label lb1 "Label 1" :label1-flag1 :label1-flag2)
					(label lb2 "Label 2" :label2-flag)))
			      '*parent*
			      (list `(list vbox lb1 lb2))))))
