#|
 This file is a part of Qtools
 (c) 2014 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.qtools)
(named-readtables:in-readtable :qt)

(define-qclass-dispatch-function copy copy-qobject (instance))

(defgeneric copy (instance)
  (:method (instance)
    (copy-qobject instance)))

(defmacro define-copy-method ((instance class) &body body)
  (let ((qt-class-name (find-qt-class-name class)))
    (if qt-class-name
        `(define-qclass-copy-function ,qt-class-name (,instance)
           ,@body)
        `(defmethod copy ((,instance ,class))
           ,@body))))

(define-copy-method (instance QBrush)
  "Returns a copy of QBrush using QBrush::QBrush."
  (#_new QBrush instance))

(define-copy-method (instance QColor)
  "Creates a new QColor using QColor::QColor."
  (#_new QColor instance))

(define-copy-method (instance QImage)
  "Uses QImage::copy to produce a copy."
  (#_copy instance (#_rect instance)))

(define-copy-method (instance QPainter)
  "Copies the QPainter by creating a new QPainter with the same device."
  (#_new QPainter (#_device instance)))

(define-copy-method (instance QPalette)
  "Shallow-copies QPalette using QPalette::QPalette."
  (#_new QPalette instance))

(define-copy-method (instance QPen)
  "Creates a new QPen using the QPen::QPen."
  (#_new QPen instance))

(define-copy-method (instance QPixmap)
  "Creates a new QPixmap using QPixmap::copy (deep copy)."
  (#_copy instance (#_rect instance)))

(define-copy-method (instance QTransform)
  "Generates a new QTransform copy by copying the transform matrix whole."
  (#_new QTransform
         (#_m11 instance) (#_m12 instance) (#_m13 instance)
         (#_m21 instance) (#_m22 instance) (#_m23 instance)
         (#_m31 instance) (#_m32 instance) (#_m33 instance)))

(define-copy-method (instance QPoint)
  "Creates a copy of the point."
  (#_new QPoint (#_x instance) (#_y instance)))

(define-copy-method (instance QPointF)
  "Creates a copy of the point."
  (#_new QPoint (#_x instance) (#_y instance)))

(define-copy-method (instance QSize)
  "Creates a copy of the size preserving w and h."
  (#_new QSize (#_width instance) (#_height instance)))

(define-copy-method (instance QSizeF)
  "Creates a copy of the size preserving w and h."
  (#_new QSize (#_width instance) (#_height instance)))

(define-copy-method (instance QRect)
  "Creates a copy of the rect preserving x, y, w, and h."
  (#_new QRect (#_x instance) (#_y instance) (#_width instance) (#_height instance)))

(define-copy-method (instance QRectF)
  "Creates a copy of the rect preserving x, y, w, and h."
  (#_new QRect (#_x instance) (#_y instance) (#_width instance) (#_height instance)))

(define-copy-method (instance QEvent)
  "Creates a new event of the same type."
  (#_new QEvent (#_type instance)))

(define-copy-method (instance QMouseEvent)
  "Creates a fresh copy of the QMouseEvent"
  (#_new QMouseEvent (#_type instance)
         (copy (#_pos instance))
         (copy (#_globalPos instance))
         (#_button instance)
         (#_buttons instance)
         (#_modifiers instance)))

(define-copy-method (instance gc-finalized)
  "Creates a new GC-Finalized object using the value of COPY on its contained object."
  (make-gc-finalized (copy (unbox instance))))

(defun describe-copy-method (class)
  (let* ((qt-class-name (find-qt-class-name class))
         (method (if qt-class-name
                     (qclass-copy-function qt-class-name)
                     (find-method #'copy () `(,(ensure-class class))))))
    (if method
        (format T "Copy method for ~:[CL class~;Qt class~] ~a.~%~:[No docstring specified.~;~:*~s~]~%"
                qt-class-name class (documentation method T))
        (format T "No copy method for the given class found.~%"))))
