
_outer_diameter = 12;
_hood_height = 11;
_clip_height = 11;

_fn = 90;


difference() {
    outer();
    inner();
    clip();
}

//
module outer() {
    od = _outer_diameter;
    od_exp = od_std + 1;
    ch = _clip_height;
    hh = _hood_height;
    total_h = ch + hh;
    
    difference() {
        union() {
            cylinder(h=total_h, r1=od, r2=od, $fn=_fn);
            translate([0, 0, ch]) {
                cylinder(h=hh, r1=od, r2=od_exp, $fn=_fn);
            }
            translate([0, 1, 0]) {
                difference() {
                    cylinder(h=total_h, r1=od, r2=od, $fn=_fn);
                    translate([-od, -od, 0]) {
                        cube([od * 2, od, total_h]);
                    }
                }
            }
        }
        
        // chamfer
        offset = 1;
        translate([0, 0, total_h - offset + 0.5]) {
            side_len = od_exp + offset;
            difference() {
                cylinder(h=side_len, r1=side_len, r2=0, $fn=_fn);
                translate([0, 0, -offset]) {
                    cylinder(h=side_len, r1=side_len, r2=0, $fn=_fn);
                }
            }
        }
    }
}

//
module inner() {
    step = 0.16;
    loop_cnt = _hood_height * (1.0 / step);
    d = (_outer_diameter - 1) * 2;
    
    translate([0, 0, _clip_height]) {
        offset_y = 2.6;  // 穴の中心位置
        small_diameter_percentage = 0.67;  // 穴の小径（レンズ側）サイズのパーセント
        
        for (i = [0 : loop_cnt]) {
            y = 0.034 * i;  // 穴の傾きを調整
            z = i * step;
            
            translate([0, -offset_y, z]) {
                linear_extrude(height=step) {
                    scale_ratio = small_diameter_percentage + 0.004 * i;  // 穴の外径（被写体側）のサイズ
                    translate([0, y, z]) {
                        scale([scale_ratio, scale_ratio]) {
                            circle(d=d, $fn=_fn);
                        }
                    }
                }
            }
        }
    }
}

//
module clip() {
    x = -_outer_diameter;
    y = -_outer_diameter - 3.5;
    z = 8.0;
    h = _clip_height - z;
    side_len = _outer_diameter * 2;
    
    translate([x, y, _clip_height - z]) {
        difference() {
            cube([side_len, side_len, z]);
            
            translate([0, side_len - 2, -4.8]) {
                rotate([30, 0, 0]) {
                    cube([side_len, 5, 5]);
                }
            }
            translate([0, side_len - 0.75, -4.8]) {
                rotate([45, 0, 0]) {
                    cube([side_len, 5, 5]);
                }
            }
            translate([0, side_len + 2.45, -1.5]) {
                rotate([59, 0, 0]) {
                    cube([side_len, 5, 5]);
                }
            }
            translate([0, side_len + 3.5, -1.5]) {
                rotate([75, 0, 0]) {
                    cube([side_len, 5, 5]);
                }
            }
            translate([0, side_len + 4.6, 1.2]) {
                rotate([85, 0, 0]) {
                    cube([side_len, 5, 5]);
                }
            }
            translate([0, side_len + 2.45, 4.7]) {
                rotate([45, 0, 0]) {
                    cube([side_len, 5, 5]);
                }
            }
        }
    }
    translate([0, 0, 1]) {
        linear_extrude(height=h) {
            circle(d=8, $fn=_fn);
        }
    }
}
