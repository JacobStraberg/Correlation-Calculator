const std = @import("std");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};

pub fn calcCorr(ally: std.mem.Allocator, x: []const f32, y: []const f32) [2]f32 {
    var array_len: usize = undefined;

    if (x.len == y.len) {
        array_len = x.len;
    } else if (x.len > y.len) {
        array_len = y.len;
    } else {}

    //1. Find the product and squares of x and y
    var backing = ally.alloc(f32, array_len * 3) catch @panic("BARF!");
    defer ally.free(backing);
    //Only need to free this one slice, instead of all three

    var xy = backing[0..array_len];
    var xx = backing[array_len..][0..array_len];
    var yy = backing[array_len * 2..][0..array_len];
    //We have just partioned the "backing" memory into three 'array_len'-sized pieces!

    var i: usize = 0;
    while (i < array_len) {
        xy[i] = x[i] * y[i];
        xx[i] = x[i] * x[i];
        yy[i] = y[i] * y[i];
        i += 1;
    }

    //2. Sum up the products and squares
    var sum_x: f32 = 0;
    var sum_y: f32 = 0;
    var sum_xy: f32 = 0;
    var sum_xx: f32 = 0;
    var sum_yy: f32 = 0;

    var j: usize = 0;
    while (j < array_len) {
        sum_x += x[j];
        sum_y += y[j];
        sum_xy += xy[j];
        sum_xx += xx[j];
        sum_yy += yy[j];
        j += 1;
    }

    //3. Calculate Pearson's correlation
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
    const p: [2]f32 = calcCorr(gpa.allocator(), x[0..], y[0..]);
    std.debug.print("p = {any}\n", .{p});
}