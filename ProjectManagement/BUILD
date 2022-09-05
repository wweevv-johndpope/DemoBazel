load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")



swift_library(
    name = "GoTrue",
    module_name = "GoTrue",
    srcs = glob(["Sources/**/*.swift"]) ,
    visibility = ["//visibility:public"],
    deps= ["GetXCFramework",]
)


apple_dynamic_xcframework_import(
    name = "GetXCFramework",
    library_identifiers = {
        "ios_device": "ios-arm64",
        "ios_simulator": "ios-arm64_x86_64-simulator",
    },
    xcframework_imports = glob(["/ThirdParty/Supabase/Get.xcframework/**"] ),
     visibility = ["//visibility:private"],
   # infoplists = ["//submodules/TelegramUI/Supabase/Get.xcframework:Info.plist"]
)