var endHookHead = function () { };
var endHookEye = function () { };
$(function () {
    var $PH = $("#pixie-head");
    $PH.get(0).addEventListener("animationend", function () {
        endHookHead();
    }, false);
    var $PE = $("#pixie-eyes");
    $PE.get(0).addEventListener("animationend", function () {
        $PE.removeClass();
        endHookEye();
    }, false);
});
function setPixieStatus(season, phase) {
    var $PH = $("#pixie-head");
    var $BG = $("#wrap-background");
    var $EYE = $("#pixie-eyes");
    setPixieStatLabel(!!season ? season.toUpperCase() : "NOTHING");
    $BG.removeClass("spring fall autumn summer");
    if (phase !== 1) {
        $BG.addClass(season);
    }
    if (phase === 1) {
        if (!$PH.hasClass("phase3")) {
            $PH.removeClass("phase0");
            $PH.removeClass("phase1");
            $PH.removeClass("phase2");
            $PH.addClass("bounceInUp animated");
            $PH.addClass("phase1");
            setTimeout(function () {
                $EYE.removeClass("dead");
                $EYE.addClass("jello animated");
                $BG.addClass(season);
                $PH.removeClass("bounceInUp animated").addClass("rubberBand animated");
            }, 500);
        }
        ;
        if ($PH.hasClass("phase3") || !season) {
            $PH.removeClass("phase0");
            $PH.removeClass("phase1");
            $PH.removeClass("phase2");
            $EYE.addClass("surprise");
            setTimeout(function () {
                $PH.addClass("hinge animated");
                endHookHead = (!!season) ? function () {
                    setTimeout(function () {
                        $PH.removeClass();
                        $PH.addClass("bounceInUp animated");
                        $PH.addClass("phase1");
                        setTimeout(function () {
                            $EYE.removeClass();
                            $EYE.addClass("jello animated");
                            $BG.addClass(season);
                            $PH.removeClass("bounceInUp animated").addClass("rubberBand animated");
                        }, 500);
                        endHookHead = function () { };
                    }, 1000);
                } : function () {
                    setTimeout(function () {
                        $PH.removeClass().addClass("phase0");
                        endHookHead = function () { };
                    }, 100);
                };
            }, 200);
        }
        ;
    }
    if (phase === 2 && $PH.hasClass("phase1")) {
        $PH.removeClass().addClass("phase2");
        endHookEye = function () {
            $EYE.removeClass();
            endHookEye = function () { };
        };
        $EYE.addClass("tada animated");
    }
    if (phase === 3 && $PH.hasClass("phase2")) {
        $PH.removeClass().addClass("phase3");
        $EYE.addClass("tired");
    }
}
function setPixieEmotion(type) {
    var $PH = $("#pixie-head");
    var $BG = $("#wrap-background");
    var $EYE = $("#pixie-eyes");
    switch (type) {
        case "shake":
            $PH.addClass("wobble animated");
            $EYE.addClass("painful");
            setTimeout(function () {
                $PH.removeClass("wobble animated");
                $EYE.removeClass("painful");
            }, 2000);
            break;
        case "hurt":
            $PH.addClass("wobble animated");
            $EYE.addClass("hurt");
            setTimeout(function () {
                $PH.removeClass("wobble animated");
                $EYE.removeClass("hurt");
            }, 2000);
            break;
        case "happy":
            $PH.addClass("wobble animated");
            $EYE.addClass("happy");
            setTimeout(function () {
                $PH.removeClass("wobble animated");
                $EYE.removeClass("happy");
            }, 2000);
            break;
    }
}
;
function setPixieName(name, old) {
    var $D = $("#pixie-stat-name");
    var oldText = !!old ? !!name ? "(" + old + "\u624D)" : old + "\u624D" : "";
    var tmp = "" + ((!!name) ? name : "") + oldText;
    $D.text(tmp);
}
function setPixieStatLabel(text) {
    var $D = $("#pixie-stat-label");
    $D.removeClass();
    setTimeout(function () {
        $D.addClass("bounceIn animated");
    }, 100);
    $D.text(text);
}
//# sourceMappingURL=main.js.map