//
// hood.scad
//
// https://github.com/miyardi/iPad-front-camera-lens-hood
// (c) 2021 MIYANISHI, Hiroki
//

_w = 21.0;
_d = 14.5;

_fn = 120;


module hood() {
    
    module slit(_x, _y, _h) {
        z = _h * 0.4;
        h = (_h - z) * 2;
        w = (_x + _y) * 0.05;
        x = _x * 0.5;
        
        offset = w * 0.7;
        
        echo(offset);
        translate([0, -offset, z]) {
            rotate([90, 0, 135]) {
                ellipse(w, h, x);
            }
        }
        translate([-offset, _y, z]) {
            rotate([90, 0, 45]) {
                ellipse(w, h, x);
            }
        }
        translate([_x + offset, 0, z]) {
            rotate([90, 0, -135]) {
                ellipse(w, h, x);
            }
        }
        translate([_x, _y + offset, z]) {
            rotate([90, 0, -45]) {
                ellipse(w, h, x);
            }
        }
    }
    
    module height_diff(_x, _y, _h, _ratio) {
        z = _h * _ratio;
        h = _h - z;
        w = _x * _ratio - 1.5; // offset
        x = (_x - w) * 0.5;
        
        translate([x, 0, z]) {
            cube([w, _y, h]);
        }
    }
    
    difference() {
        h = 10;
        th = 0.9;
        
        union () {
            ellipse(_w, _d, h);
            translate([0, _d * 0.5, 0]) {
                cube([_w, _d * 0.5 + 3.6, th * 1.2]);
            }
        }
        
        translate([th, th, 0]) {
            th_x2 = th * 2;
            ellipse(_w - th_x2, _d - th_x2, h, 1.3);
        }
        slit(_w, _d, h);
        height_diff(_w, _d, h, 3.2 / 4);
    }
}


module clip() {
    th = 1.6;
    h = 32;
    d = 9 + th + th;
    w = _w / 3;
    
    h_front = 9.4;
    
    difference() {
        angle = 4;
        
        union () {
            cube([_w, th, h_front]);
            cube([_w, th + th, th]);
            
            translate([0, 0, 0]) {
                cube([w, d, th]);
                translate([w, d - th - 1, th]) {
                    bevel(1, w, [0, -90, 0]);
                }
            }
            
            translate([w + w, 0, 0]) {
                cube([w, d, th]);
                translate([w, d - th - 1, th]) {
                    bevel(1, w, [0, -90, 0]);
                }
            }
            
            rotate([angle, 0, 0]) {
                difference() {
                    translate([0, d - th, 0]) {
                        cube([_w, th, h]);
                    }
                    hole_h = 22;
                    translate([w, d, -hole_h]) {
                        rotate([90, 0, 0]) {
                            ellipse(w, hole_h * 2, th);
                        }
                    }
                }
            }
        } // union
        
        translate([_w, 1, h_front]) {
            bevel(1, _w, [180, 90, 0]);
        }
        
        rotate([angle, 0, 0]) {
            translate([0, d, 0]) {
                cube([_w, th, h]);
            }
            translate([0, d - 1, 0]) {
                bevel(1, h, [0, 0, 0]);
            }
            translate([_w - 1, d, 0]) {
                bevel(1, h, [0, 0, -90]);
            }
            translate([0, d - 1, h]) {
                bevel(1, _w, [0, 90, 0]);
            }
        }
        
        translate([0, 1, 0]) {
            bevel(1, _w, [0, -90, 180]);
        }
        translate([0, 0, 1]) {
            bevel(1, d, [-90, 0, 0]);
        }
        
        translate([_w, d - 1, 0]) {
            bevel(1, _w, [0, -90, 0]);
        }
        translate([_w - 1, 0, 0]) {
            bevel(1, d, [-90, -90, 0]);
        }
        
        translate([0, d - 1, 0]) {
            bevel(1, th, [0, 0, 0]);
        }
        translate([_w - 1, d, 0]) {
            bevel(1, th, [180, 180, 90]);
        }
        
        translate([0, th, 5.4]) {
            rotate([90, 0, 0]) {
                ellipse(_w, _d, th);
            }
        }
    }
}


module ellipse(w, d, h, r_ratio=1) {
    translate([w * 0.5, d * 0.5, 0]) {
        resize([w, d, 0]) {
            cylinder(h=h, r1=1, r2=r_ratio, $fn=_fn);
        }
    }
}

module bevel(d, h, a) {
    rotate(a) {
        difference() {
            cube([d, d, h]);
            translate([d, 0, 0]) {
                cylinder(h=h, r=d, $fn=_fn);
            }
        }
    }
}


translate([0, 0, 0]) {
    hood();
}
translate([0, 19, 0]) {
    clip();
}
