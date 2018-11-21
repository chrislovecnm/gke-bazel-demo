java_library(
    name = "log4j_api",
    exports = [
        "//external:jar/org/apache/logging/log4j/log4j_api"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)



java_library(
    name = "log4j_to_slf4j",
    exports = [
        "//3rdparty/jvm/org/slf4j:slf4j_api",
        "//external:jar/org/apache/logging/log4j/log4j_to_slf4j",
        ":log4j_api"
    ],
    visibility = [
        "//3rdparty/jvm:__subpackages__"
    ]
)


