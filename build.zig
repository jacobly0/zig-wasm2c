const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const build_mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const exe = b.addExecutable("zig-wasm2c", "src/main.c");
    exe.setBuildMode(build_mode);
    exe.setTarget(target);
    exe.addCSourceFiles(&.{
        "src/zstd/lib/common/entropy_common.c",
        "src/zstd/lib/common/error_private.c",
        "src/zstd/lib/common/fse_decompress.c",
        "src/zstd/lib/common/xxhash.c",
        "src/zstd/lib/common/zstd_common.c",
        "src/zstd/lib/decompress/huf_decompress.c",
        "src/zstd/lib/decompress/zstd_ddict.c",
        "src/zstd/lib/decompress/zstd_decompress.c",
        "src/zstd/lib/decompress/zstd_decompress_block.c",
    }, &.{ "-DZSTD_DISABLE_ASM", "-pedantic", "-Wall", "-Wextra", "-Werror" });
    exe.linkLibC();
    exe.install();

    const run = exe.run();
    if (b.args) |args| run.addArgs(args);

    const run_step = b.step("run", "Run zig-wasm2c");
    run_step.dependOn(&run.step);
}
