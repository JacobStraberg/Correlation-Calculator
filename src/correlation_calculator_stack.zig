const std = @import("std");

pub fn calcCorr(x: []const f32, y: []const f32) [2]f32 {
    var array_len: usize = undefined;

    if (x.len == y.len) {
        array_len = x.len;
    } else if (x.len > y.len) {
        array_len = y.len;
    } else {}

    //1. Sum up all the products and squares
    var sum_x: f32 = 0;
    var sum_y: f32 = 0;
    var sum_xy: f32 = 0;
    var sum_xx: f32 = 0;
    var sum_yy: f32 = 0;

    var i: usize = 0;
    while (i < array_len) : (i += 1) {
        sum_x += x[i];
        sum_y += y[i];
        sum_xy += x[i] * y[i];
        sum_xx += x[i] * x[i];
        sum_yy += y[i] * y[i];
    }

    //2. Calculate Pearson's correlation
    var array_len_float: f32 = @intToFloat(f32, array_len);
    var numerator: f32 = (array_len_float * sum_xy) - (sum_x * sum_y);
    var denominator: f32 = (array_len_float * sum_xx - (sum_x * sum_x)) * (array_len_float * sum_yy - (sum_y * sum_y));
    var r: f32 = numerator / @sqrt(denominator);
    var r_squared: f32 = r * r;

    return [2]f32{ r, r_squared };
}

test {
    const x = [3]f32{ 6, 8, 10 };
    const y = [3]f32{ 12, 10, 20 };
    const p: [2]f32 = calcCorr(x[0..], y[0..]);
    std.debug.print("p = {any}\n", .{p});
}