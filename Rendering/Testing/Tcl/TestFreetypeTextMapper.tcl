package require vtk
package require vtkinteraction

set current_font_size 16

set default_text "ABCDEFGHIJKLMnopqrstuvwxyz 0123456789 !@#$%()-=_+[]{};:,./<>?"

set text_color [list [expr 246 / 255.0] [expr 255 / 255.0] [expr 11 / 255.0]]
set bg_color [list [expr 56 / 255.0] [expr 56 / 255.0] [expr 154 / 255.0]]

vtkRenderWindow renWin
    renWin SetSize 790 350

vtkRenderer ren1
    eval ren1 SetBackground $bg_color
    renWin AddRenderer ren1

vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin
iren AddObserver UserEvent {wm deiconify .vtkInteract}

set i 0

foreach family {
    Arial 
    Courier 
    Times
} {
    foreach {bold italic shadow} {
        0 0 0
        0 0 1
        1 0 0
        0 1 0
        1 1 0
    } {
        incr i

        set attribs {}
        if {$bold} {
            lappend attribs "b"
        }
        if {$italic} {
            lappend attribs "i"
        }
        if {$shadow} {
            lappend attribs "s"
        }
        set face_name "$family"
        if {[llength $attribs]} {
            set face_name "$face_name ([join $attribs ,])"
        }

        set mapper [vtkOpenGLFreeTypeTextMapper mapper_${family}_${bold}_${italic}_${shadow}]
        $mapper SetInput "$face_name: $default_text"

        set tprop [$mapper GetTextProperty]
        eval $tprop SetFontFamilyTo$family
        eval $tprop SetColor $text_color
        $tprop SetBold $bold
        $tprop SetItalic $italic
        $tprop SetShadow $shadow
        $tprop SetFontSize $current_font_size

        set actor [vtkActor2D actor_${family}_${bold}_${italic}_${shadow}]
        $actor SetMapper $mapper
        $actor SetDisplayPosition 10 [expr $i * ($current_font_size + 5)]

        ren1 AddActor $actor
    }
}

renWin Render

# prevent the tk window from showing up then start the event loop
wm withdraw .

