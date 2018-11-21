# The following dependencies were calculated from:
#
# generate_workspace --maven_project=/Users/mmatthias/helmsman/helmsman-gke-bazel-demo/java-spring-boot/ --artifact=org.springframework.boot:spring-boot-starter-web:2.1.0.RELEASE --repositories=http://central.maven.org/maven2/


def generated_maven_jars():
  # org.springframework.boot:spring-boot-starter-tomcat:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "javax_annotation_javax_annotation_api",
      artifact = "javax.annotation:javax.annotation-api:1.3.2",
      repository = "http://central.maven.org/maven2/",
      sha1 = "934c04d3cfef185a8008e7bf34331b79730a9d43",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_skyscreamer_jsonassert",
      artifact = "org.skyscreamer:jsonassert:1.5.0",
      repository = "http://central.maven.org/maven2/",
      sha1 = "6c9d5fe2f59da598d9aefc1cfc6528ff3cf32df3",
  )


  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_hibernate_validator_hibernate_validator",
      artifact = "org.hibernate.validator:hibernate-validator:6.0.13.Final",
      repository = "http://central.maven.org/maven2/",
      sha1 = "af4232bf90ecd33c71147d67185dbb1cfe8f33df",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "com_jayway_jsonpath_json_path",
      artifact = "com.jayway.jsonpath:json-path:2.4.0",
      repository = "http://central.maven.org/maven2/",
      sha1 = "765a4401ceb2dc8d40553c2075eb80a8fa35c2ae",
  )


  # org.springframework.boot:spring-boot-starter-logging:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_slf4j_jul_to_slf4j",
      artifact = "org.slf4j:jul-to-slf4j:1.7.25",
      repository = "http://central.maven.org/maven2/",
      sha1 = "0af5364cd6679bfffb114f0dec8a157aaa283b76",
  )


  # org.springframework:spring-context:jar:5.1.2.RELEASE
  # org.springframework:spring-webmvc:jar:5.1.2.RELEASE got requested version
  native.maven_jar(
      name = "org_springframework_spring_expression",
      artifact = "org.springframework:spring-expression:5.1.2.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "03c16b062785e4c101db6b754fcb34a77c1e912c",
  )


  # org.hibernate.validator:hibernate-validator:jar:6.0.13.Final
  native.maven_jar(
      name = "org_jboss_logging_jboss_logging",
      artifact = "org.jboss.logging:jboss-logging:3.3.2.Final",
      repository = "http://central.maven.org/maven2/",
      sha1 = "3789d00e859632e6c6206adc0c71625559e6e3b0",
  )


  # net.minidev:accessors-smart:bundle:1.2
  native.maven_jar(
      name = "org_ow2_asm_asm",
      artifact = "org.ow2.asm:asm:5.0.4",
      repository = "http://central.maven.org/maven2/",
      sha1 = "0da08b8cce7bbf903602a25a3a163ae252435795",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_assertj_assertj_core",
      artifact = "org.assertj:assertj-core:3.11.1",
      repository = "http://central.maven.org/maven2/",
      sha1 = "fdac3217b804d6900fa3650f17b5cb48e620b140",
  )


  # org.springframework.boot:spring-boot-starter-json:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "com_fasterxml_jackson_datatype_jackson_datatype_jdk8",
      artifact = "com.fasterxml.jackson.datatype:jackson-datatype-jdk8:2.9.7",
      repository = "http://central.maven.org/maven2/",
      sha1 = "98d8f190db07f97c64c0ea3af5792f718a6c2cc1",
  )


  # org.springframework.boot:spring-boot-starter-json:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "com_fasterxml_jackson_datatype_jackson_datatype_jsr310",
      artifact = "com.fasterxml.jackson.datatype:jackson-datatype-jsr310:2.9.7",
      repository = "http://central.maven.org/maven2/",
      sha1 = "cbd919f1ce67533e07b98dd493247e8dbabc26b2",
  )


  # pom.xml got requested version
  # org.example:restexample:jar:0.1.0
  native.maven_jar(
      name = "org_springframework_boot_spring_boot_starter_test",
      artifact = "org.springframework.boot:spring-boot-starter-test:2.1.0.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "8560b42bb7d9f19b63d722d50bc9a660c2bbd9f3",
  )


  # org.mockito:mockito-core:jar:2.23.0
  native.maven_jar(
      name = "org_objenesis_objenesis",
      artifact = "org.objenesis:objenesis:2.6",
      repository = "http://central.maven.org/maven2/",
      sha1 = "639033469776fd37c08358c6b92a4761feb2af4b",
  )


  # org.hibernate.validator:hibernate-validator:jar:6.0.13.Final
  native.maven_jar(
      name = "javax_validation_validation_api",
      artifact = "javax.validation:validation-api:2.0.1.Final",
      repository = "http://central.maven.org/maven2/",
      sha1 = "cb855558e6271b1b32e716d24cb85c7f583ce09e",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE got requested version
  # org.hamcrest:hamcrest-library:jar:1.3 got requested version
  # junit:junit:jar:4.12
  native.maven_jar(
      name = "org_hamcrest_hamcrest_core",
      artifact = "org.hamcrest:hamcrest-core:1.3",
      repository = "http://central.maven.org/maven2/",
      sha1 = "42a25dc3219429f0e5d060061f71acb49bf010a0",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter-json:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_springframework_boot_spring_boot_starter",
      artifact = "org.springframework.boot:spring-boot-starter:2.1.0.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "54eab30f1be3dd2f1e833e26143f6243246d878d",
  )


  # org.skyscreamer:jsonassert:jar:1.5.0
  native.maven_jar(
      name = "com_vaadin_external_google_android_json",
      artifact = "com.vaadin.external.google:android-json:0.0.20131108.vaadin1",
      repository = "http://central.maven.org/maven2/",
      sha1 = "fa26d351fe62a6a17f5cda1287c1c6110dec413f",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE
  # org.springframework.boot:spring-boot-test-autoconfigure:jar:2.1.0.RELEASE got requested version
  native.maven_jar(
      name = "org_springframework_boot_spring_boot_test",
      artifact = "org.springframework.boot:spring-boot-test:2.1.0.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "ec05836d27eb6d102e45f3927d53e4a4fe215f01",
  )


  # org.hibernate.validator:hibernate-validator:jar:6.0.13.Final
  native.maven_jar(
      name = "com_fasterxml_classmate",
      artifact = "com.fasterxml:classmate:1.3.4",
      repository = "http://central.maven.org/maven2/",
      sha1 = "03d5f48f10bbe4eb7bd862f10c0583be2e0053c6",
  )


  native.maven_jar(
      name = "org_springframework_boot_spring_boot_starter_web",
      artifact = "org.springframework.boot:spring-boot-starter-web:2.1.0.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "5bb07547b965e84edd8abb49c1431d17926e2c6b",
  )


  # com.fasterxml.jackson.module:jackson-module-parameter-names:bundle:2.9.7 got requested version
  # org.springframework.boot:spring-boot-starter-json:jar:2.1.0.RELEASE
  # com.fasterxml.jackson.datatype:jackson-datatype-jdk8:bundle:2.9.7 got requested version
  # com.fasterxml.jackson.datatype:jackson-datatype-jsr310:bundle:2.9.7 got requested version
  native.maven_jar(
      name = "com_fasterxml_jackson_core_jackson_databind",
      artifact = "com.fasterxml.jackson.core:jackson-databind:2.9.7",
      repository = "http://central.maven.org/maven2/",
      sha1 = "e6faad47abd3179666e89068485a1b88a195ceb7",
  )


  # org.springframework.boot:spring-boot-starter-tomcat:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_apache_tomcat_embed_tomcat_embed_websocket",
      artifact = "org.apache.tomcat.embed:tomcat-embed-websocket:9.0.12",
      repository = "http://central.maven.org/maven2/",
      sha1 = "b55259721a6f872107e0299a19bd1ed3998168ef",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE got requested version
  # org.springframework:spring-webmvc:jar:5.1.2.RELEASE got requested version
  # org.springframework.boot:spring-boot:jar:2.1.0.RELEASE
  # org.springframework:spring-beans:jar:5.1.2.RELEASE got requested version
  # org.springframework:spring-aop:jar:5.1.2.RELEASE got requested version
  # org.springframework:spring-web:jar:5.1.2.RELEASE got requested version
  # org.springframework:spring-expression:jar:5.1.2.RELEASE got requested version
  # org.springframework:spring-context:jar:5.1.2.RELEASE got requested version
  # org.springframework:spring-test:jar:5.1.2.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter:jar:2.1.0.RELEASE got requested version
  native.maven_jar(
      name = "org_springframework_spring_core",
      artifact = "org.springframework:spring-core:5.1.2.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "b9b00d4075c92761cfd4e527e0bdce1931b4f3dc",
  )


  # com.fasterxml.jackson.module:jackson-module-parameter-names:bundle:2.9.7 got requested version
  # com.fasterxml.jackson.core:jackson-databind:bundle:2.9.7
  # com.fasterxml.jackson.datatype:jackson-datatype-jdk8:bundle:2.9.7 got requested version
  # com.fasterxml.jackson.datatype:jackson-datatype-jsr310:bundle:2.9.7 got requested version
  native.maven_jar(
      name = "com_fasterxml_jackson_core_jackson_core",
      artifact = "com.fasterxml.jackson.core:jackson-core:2.9.7",
      repository = "http://central.maven.org/maven2/",
      sha1 = "4b7f0e0dc527fab032e9800ed231080fdc3ac015",
  )


  # org.springframework.boot:spring-boot-starter-logging:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "ch_qos_logback_logback_classic",
      artifact = "ch.qos.logback:logback-classic:1.2.3",
      repository = "http://central.maven.org/maven2/",
      sha1 = "7c4f3c474fb2c041d8028740440937705ebb473a",
  )


  # org.springframework.boot:spring-boot-starter-tomcat:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_apache_tomcat_embed_tomcat_embed_el",
      artifact = "org.apache.tomcat.embed:tomcat-embed-el:9.0.12",
      repository = "http://central.maven.org/maven2/",
      sha1 = "8ee44bee76043321860cde871cf6343de1483ff5",
  )


  # org.mockito:mockito-core:jar:2.23.0
  native.maven_jar(
      name = "net_bytebuddy_byte_buddy_agent",
      artifact = "net.bytebuddy:byte-buddy-agent:1.9.0",
      repository = "http://central.maven.org/maven2/",
      sha1 = "37b5703b4a6290be3fffc63ae9c6bcaaee0ff856",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_springframework_spring_test",
      artifact = "org.springframework:spring-test:5.1.2.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "ba68aac1da4bdb4899053aa6c562f049c64cabf4",
  )


  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_springframework_boot_spring_boot_starter_json",
      artifact = "org.springframework.boot:spring-boot-starter-json:2.1.0.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "704c38f5c3ad5205701391110dd4c6f5623fb2cc",
  )


  # org.springframework:spring-webmvc:jar:5.1.2.RELEASE got requested version
  # org.springframework.boot:spring-boot:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_springframework_spring_context",
      artifact = "org.springframework:spring-context:5.1.2.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "5c85bc522a5adac9b09b7204fa20708519ab6a11",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_mockito_mockito_core",
      artifact = "org.mockito:mockito-core:2.23.0",
      repository = "http://central.maven.org/maven2/",
      sha1 = "497ddb32fd5d01f9dbe99a2ec790aeb931dff1b1",
  )


  # org.springframework:spring-context:jar:5.1.2.RELEASE
  # org.springframework:spring-webmvc:jar:5.1.2.RELEASE got requested version
  native.maven_jar(
      name = "org_springframework_spring_aop",
      artifact = "org.springframework:spring-aop:5.1.2.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "bc3cdf3c81bc0a3482cc7f6b9e00ab76847056a7",
  )


  # org.springframework.boot:spring-boot-starter-logging:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_apache_logging_log4j_log4j_to_slf4j",
      artifact = "org.apache.logging.log4j:log4j-to-slf4j:2.11.1",
      repository = "http://central.maven.org/maven2/",
      sha1 = "1097acadf76aa4dd721ec5807566003ae9d975de",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_springframework_boot_spring_boot_test_autoconfigure",
      artifact = "org.springframework.boot:spring-boot-test-autoconfigure:2.1.0.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "aee75f4d50d31ced28638f5c9ea9c4133d5542cd",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_xmlunit_xmlunit_core",
      artifact = "org.xmlunit:xmlunit-core:2.6.2",
      repository = "http://central.maven.org/maven2/",
      sha1 = "b0461888cdd8d3975ea8a57df96520409cadcb6c",
  )


  # org.apache.logging.log4j:log4j-to-slf4j:jar:2.11.1
  native.maven_jar(
      name = "org_apache_logging_log4j_log4j_api",
      artifact = "org.apache.logging.log4j:log4j-api:2.11.1",
      repository = "http://central.maven.org/maven2/",
      sha1 = "268f0fe4df3eefe052b57c87ec48517d64fb2a10",
  )


  # org.springframework.boot:spring-boot-starter:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_springframework_boot_spring_boot_starter_logging",
      artifact = "org.springframework.boot:spring-boot-starter-logging:2.1.0.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "d1bd872e05961f30bc122ad14f3e9ae12388e873",
  )


  # ch.qos.logback:logback-classic:jar:1.2.3
  native.maven_jar(
      name = "ch_qos_logback_logback_core",
      artifact = "ch.qos.logback:logback-core:1.2.3",
      repository = "http://central.maven.org/maven2/",
      sha1 = "864344400c3d4d92dfeb0a305dc87d953677c03c",
  )


  # com.jayway.jsonpath:json-path:jar:2.4.0
  native.maven_jar(
      name = "net_minidev_json_smart",
      artifact = "net.minidev:json-smart:2.3",
      repository = "http://central.maven.org/maven2/",
      sha1 = "007396407491352ce4fa30de92efb158adb76b5b",
  )


  # org.mockito:mockito-core:jar:2.23.0
  native.maven_jar(
      name = "net_bytebuddy_byte_buddy",
      artifact = "net.bytebuddy:byte-buddy:1.9.0",
      repository = "http://central.maven.org/maven2/",
      sha1 = "8cb0d5baae526c9df46ae17693bbba302640538b",
  )


  # org.springframework.boot:spring-boot-test:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-autoconfigure:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_springframework_boot_spring_boot",
      artifact = "org.springframework.boot:spring-boot:2.1.0.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "a78c97c771856f7690b9308886c75affe9295b12",
  )


  # org.springframework.boot:spring-boot-starter-json:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "com_fasterxml_jackson_module_jackson_module_parameter_names",
      artifact = "com.fasterxml.jackson.module:jackson-module-parameter-names:2.9.7",
      repository = "http://central.maven.org/maven2/",
      sha1 = "f2bdd7696beffa2dbc5dc62cd24c3906a40ffcff",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_hamcrest_hamcrest_library",
      artifact = "org.hamcrest:hamcrest-library:1.3",
      repository = "http://central.maven.org/maven2/",
      sha1 = "4785a3c21320980282f9f33d0d1264a69040538f",
  )


  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_springframework_boot_spring_boot_starter_tomcat",
      artifact = "org.springframework.boot:spring-boot-starter-tomcat:2.1.0.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "e3d4a04f0e678f65d5bb283fbef67bfbd05b5ca1",
  )


  # org.springframework.boot:spring-boot-starter-test:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "junit_junit",
      artifact = "junit:junit:4.12",
      repository = "http://central.maven.org/maven2/",
      sha1 = "2973d150c0dc1fefe998f834810d68f278ea58ec",
  )


  # net.minidev:json-smart:bundle:2.3
  native.maven_jar(
      name = "net_minidev_accessors_smart",
      artifact = "net.minidev:accessors-smart:1.2",
      repository = "http://central.maven.org/maven2/",
      sha1 = "c592b500269bfde36096641b01238a8350f8aa31",
  )


  # org.apache.logging.log4j:log4j-to-slf4j:jar:2.11.1 got requested version
  # com.jayway.jsonpath:json-path:jar:2.4.0 got requested version
  # ch.qos.logback:logback-classic:jar:1.2.3
  # org.slf4j:jul-to-slf4j:jar:1.7.25 got requested version
  native.maven_jar(
      name = "org_slf4j_slf4j_api",
      artifact = "org.slf4j:slf4j-api:1.7.25",
      repository = "http://central.maven.org/maven2/",
      sha1 = "da76ca59f6a57ee3102f8f9bd9cee742973efa8a",
  )


  # org.apache.tomcat.embed:tomcat-embed-websocket:jar:9.0.12 got requested version
  # org.springframework.boot:spring-boot-starter-tomcat:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_apache_tomcat_embed_tomcat_embed_core",
      artifact = "org.apache.tomcat.embed:tomcat-embed-core:9.0.12",
      repository = "http://central.maven.org/maven2/",
      sha1 = "0136c8dc5c84e82bf2d68bb10648d4fa8b402184",
  )


  # org.springframework.boot:spring-boot-test-autoconfigure:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_springframework_boot_spring_boot_autoconfigure",
      artifact = "org.springframework.boot:spring-boot-autoconfigure:2.1.0.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "8898af6accfab65ac6e232c1535abbc33cfa5fcb",
  )


  # com.fasterxml.jackson.core:jackson-databind:bundle:2.9.7
  # com.fasterxml.jackson.datatype:jackson-datatype-jsr310:bundle:2.9.7 got requested version
  native.maven_jar(
      name = "com_fasterxml_jackson_core_jackson_annotations",
      artifact = "com.fasterxml.jackson.core:jackson-annotations:2.9.0",
      repository = "http://central.maven.org/maven2/",
      sha1 = "07c10d545325e3a6e72e06381afe469fd40eb701",
  )


  # org.springframework:spring-webmvc:jar:5.1.2.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter-json:jar:2.1.0.RELEASE
  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE got requested version
  native.maven_jar(
      name = "org_springframework_spring_web",
      artifact = "org.springframework:spring-web:5.1.2.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "3ff2a93b072da42c3930225e3dceeabb0678eb0b",
  )


  # org.springframework:spring-core:jar:5.1.2.RELEASE
  native.maven_jar(
      name = "org_springframework_spring_jcl",
      artifact = "org.springframework:spring-jcl:5.1.2.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "f0d7165b6cfb90356da4f25b14a6437fdef1ec8a",
  )


  # org.springframework:spring-webmvc:jar:5.1.2.RELEASE got requested version
  # org.springframework:spring-web:jar:5.1.2.RELEASE got requested version
  # org.springframework:spring-context:jar:5.1.2.RELEASE got requested version
  # org.springframework:spring-aop:jar:5.1.2.RELEASE
  native.maven_jar(
      name = "org_springframework_spring_beans",
      artifact = "org.springframework:spring-beans:5.1.2.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "5d513701a79c92f0549574f5170a05c4af7c893d",
  )


  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE got requested version
  # org.springframework.boot:spring-boot-starter-web:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_springframework_spring_webmvc",
      artifact = "org.springframework:spring-webmvc:5.1.2.RELEASE",
      repository = "http://central.maven.org/maven2/",
      sha1 = "46e1db300d855ddef6b71816bb52856f46d6003f",
  )


  # org.springframework.boot:spring-boot-starter:jar:2.1.0.RELEASE
  native.maven_jar(
      name = "org_yaml_snakeyaml",
      artifact = "org.yaml:snakeyaml:1.23",
      repository = "http://central.maven.org/maven2/",
      sha1 = "ec62d74fe50689c28c0ff5b35d3aebcaa8b5be68",
  )




def generated_java_libraries():
  native.java_library(
      name = "javax_annotation_javax_annotation_api",
      visibility = ["//visibility:public"],
      exports = ["@javax_annotation_javax_annotation_api//jar"],
  )


  native.java_library(
      name = "org_skyscreamer_jsonassert",
      visibility = ["//visibility:public"],
      exports = ["@org_skyscreamer_jsonassert//jar"],
      runtime_deps = [
          ":com_vaadin_external_google_android_json",
      ],
  )


  native.java_library(
      name = "org_hibernate_validator_hibernate_validator",
      visibility = ["//visibility:public"],
      exports = ["@org_hibernate_validator_hibernate_validator//jar"],
      runtime_deps = [
          ":com_fasterxml_classmate",
          ":javax_validation_validation_api",
          ":org_jboss_logging_jboss_logging",
      ],
  )


  native.java_library(
      name = "com_jayway_jsonpath_json_path",
      visibility = ["//visibility:public"],
      exports = ["@com_jayway_jsonpath_json_path//jar"],
      runtime_deps = [
          ":net_minidev_accessors_smart",
          ":net_minidev_json_smart",
          ":org_ow2_asm_asm",
          ":org_slf4j_slf4j_api",
      ],
  )


  native.java_library(
      name = "org_slf4j_jul_to_slf4j",
      visibility = ["//visibility:public"],
      exports = ["@org_slf4j_jul_to_slf4j//jar"],
      runtime_deps = [
          ":org_slf4j_slf4j_api",
      ],
  )


  native.java_library(
      name = "org_springframework_spring_expression",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_spring_expression//jar"],
      runtime_deps = [
          ":org_springframework_spring_core",
      ],
  )


  native.java_library(
      name = "org_jboss_logging_jboss_logging",
      visibility = ["//visibility:public"],
      exports = ["@org_jboss_logging_jboss_logging//jar"],
  )


  native.java_library(
      name = "org_ow2_asm_asm",
      visibility = ["//visibility:public"],
      exports = ["@org_ow2_asm_asm//jar"],
  )


  native.java_library(
      name = "org_assertj_assertj_core",
      visibility = ["//visibility:public"],
      exports = ["@org_assertj_assertj_core//jar"],
  )


  native.java_library(
      name = "com_fasterxml_jackson_datatype_jackson_datatype_jdk8",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_jackson_datatype_jackson_datatype_jdk8//jar"],
      runtime_deps = [
          ":com_fasterxml_jackson_core_jackson_core",
          ":com_fasterxml_jackson_core_jackson_databind",
      ],
  )


  native.java_library(
      name = "com_fasterxml_jackson_datatype_jackson_datatype_jsr310",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_jackson_datatype_jackson_datatype_jsr310//jar"],
      runtime_deps = [
          ":com_fasterxml_jackson_core_jackson_annotations",
          ":com_fasterxml_jackson_core_jackson_core",
          ":com_fasterxml_jackson_core_jackson_databind",
      ],
  )


  native.java_library(
      name = "org_springframework_boot_spring_boot_starter_test",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_boot_spring_boot_starter_test//jar"],
      runtime_deps = [
          ":com_jayway_jsonpath_json_path",
          ":com_vaadin_external_google_android_json",
          ":junit_junit",
          ":net_bytebuddy_byte_buddy",
          ":net_bytebuddy_byte_buddy_agent",
          ":net_minidev_accessors_smart",
          ":net_minidev_json_smart",
          ":org_assertj_assertj_core",
          ":org_hamcrest_hamcrest_core",
          ":org_hamcrest_hamcrest_library",
          ":org_mockito_mockito_core",
          ":org_objenesis_objenesis",
          ":org_ow2_asm_asm",
          ":org_skyscreamer_jsonassert",
          ":org_slf4j_slf4j_api",
          ":org_springframework_boot_spring_boot",
          ":org_springframework_boot_spring_boot_autoconfigure",
          ":org_springframework_boot_spring_boot_starter",
          ":org_springframework_boot_spring_boot_test",
          ":org_springframework_boot_spring_boot_test_autoconfigure",
          ":org_springframework_spring_core",
          ":org_springframework_spring_test",
          ":org_xmlunit_xmlunit_core",
      ],
  )


  native.java_library(
      name = "org_objenesis_objenesis",
      visibility = ["//visibility:public"],
      exports = ["@org_objenesis_objenesis//jar"],
  )


  native.java_library(
      name = "javax_validation_validation_api",
      visibility = ["//visibility:public"],
      exports = ["@javax_validation_validation_api//jar"],
  )


  native.java_library(
      name = "org_hamcrest_hamcrest_core",
      visibility = ["//visibility:public"],
      exports = ["@org_hamcrest_hamcrest_core//jar"],
  )


  native.java_library(
      name = "org_springframework_boot_spring_boot_starter",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_boot_spring_boot_starter//jar"],
      runtime_deps = [
          ":ch_qos_logback_logback_classic",
          ":ch_qos_logback_logback_core",
          ":javax_annotation_javax_annotation_api",
          ":org_apache_logging_log4j_log4j_api",
          ":org_apache_logging_log4j_log4j_to_slf4j",
          ":org_slf4j_jul_to_slf4j",
          ":org_slf4j_slf4j_api",
          ":org_springframework_boot_spring_boot",
          ":org_springframework_boot_spring_boot_autoconfigure",
          ":org_springframework_boot_spring_boot_starter_logging",
          ":org_springframework_spring_aop",
          ":org_springframework_spring_beans",
          ":org_springframework_spring_context",
          ":org_springframework_spring_core",
          ":org_springframework_spring_expression",
          ":org_springframework_spring_jcl",
          ":org_yaml_snakeyaml",
      ],
  )


  native.java_library(
      name = "com_vaadin_external_google_android_json",
      visibility = ["//visibility:public"],
      exports = ["@com_vaadin_external_google_android_json//jar"],
  )


  native.java_library(
      name = "org_springframework_boot_spring_boot_test",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_boot_spring_boot_test//jar"],
      runtime_deps = [
          ":org_springframework_boot_spring_boot",
      ],
  )


  native.java_library(
      name = "com_fasterxml_classmate",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_classmate//jar"],
  )


  native.java_library(
      name = "org_springframework_boot_spring_boot_starter_web",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_boot_spring_boot_starter_web//jar"],
      runtime_deps = [
          ":org_hibernate_validator_hibernate_validator",
          ":org_springframework_boot_spring_boot_starter",
          ":org_springframework_boot_spring_boot_starter_json",
          ":org_springframework_boot_spring_boot_starter_tomcat",
          ":org_springframework_spring_web",
          ":org_springframework_spring_webmvc",
      ],
  )


  native.java_library(
      name = "com_fasterxml_jackson_core_jackson_databind",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_jackson_core_jackson_databind//jar"],
      runtime_deps = [
          ":com_fasterxml_jackson_core_jackson_annotations",
          ":com_fasterxml_jackson_core_jackson_core",
      ],
  )


  native.java_library(
      name = "org_apache_tomcat_embed_tomcat_embed_websocket",
      visibility = ["//visibility:public"],
      exports = ["@org_apache_tomcat_embed_tomcat_embed_websocket//jar"],
      runtime_deps = [
          ":org_apache_tomcat_embed_tomcat_embed_core",
      ],
  )


  native.java_library(
      name = "org_springframework_spring_core",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_spring_core//jar"],
      runtime_deps = [
          ":org_springframework_spring_jcl",
      ],
  )


  native.java_library(
      name = "com_fasterxml_jackson_core_jackson_core",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_jackson_core_jackson_core//jar"],
  )


  native.java_library(
      name = "ch_qos_logback_logback_classic",
      visibility = ["//visibility:public"],
      exports = ["@ch_qos_logback_logback_classic//jar"],
      runtime_deps = [
          ":ch_qos_logback_logback_core",
          ":org_slf4j_slf4j_api",
      ],
  )


  native.java_library(
      name = "org_apache_tomcat_embed_tomcat_embed_el",
      visibility = ["//visibility:public"],
      exports = ["@org_apache_tomcat_embed_tomcat_embed_el//jar"],
  )


  native.java_library(
      name = "net_bytebuddy_byte_buddy_agent",
      visibility = ["//visibility:public"],
      exports = ["@net_bytebuddy_byte_buddy_agent//jar"],
  )


  native.java_library(
      name = "org_springframework_spring_test",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_spring_test//jar"],
      runtime_deps = [
          ":org_springframework_spring_core",
      ],
  )


  native.java_library(
      name = "org_springframework_boot_spring_boot_starter_json",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_boot_spring_boot_starter_json//jar"],
      runtime_deps = [
          ":com_fasterxml_jackson_core_jackson_annotations",
          ":com_fasterxml_jackson_core_jackson_core",
          ":com_fasterxml_jackson_core_jackson_databind",
          ":com_fasterxml_jackson_datatype_jackson_datatype_jdk8",
          ":com_fasterxml_jackson_datatype_jackson_datatype_jsr310",
          ":com_fasterxml_jackson_module_jackson_module_parameter_names",
          ":org_springframework_boot_spring_boot_starter",
          ":org_springframework_spring_beans",
          ":org_springframework_spring_core",
          ":org_springframework_spring_web",
      ],
  )


  native.java_library(
      name = "org_springframework_spring_context",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_spring_context//jar"],
      runtime_deps = [
          ":org_springframework_spring_aop",
          ":org_springframework_spring_beans",
          ":org_springframework_spring_core",
          ":org_springframework_spring_expression",
      ],
  )


  native.java_library(
      name = "org_mockito_mockito_core",
      visibility = ["//visibility:public"],
      exports = ["@org_mockito_mockito_core//jar"],
      runtime_deps = [
          ":net_bytebuddy_byte_buddy",
          ":net_bytebuddy_byte_buddy_agent",
          ":org_objenesis_objenesis",
      ],
  )


  native.java_library(
      name = "org_springframework_spring_aop",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_spring_aop//jar"],
      runtime_deps = [
          ":org_springframework_spring_beans",
          ":org_springframework_spring_core",
      ],
  )


  native.java_library(
      name = "org_apache_logging_log4j_log4j_to_slf4j",
      visibility = ["//visibility:public"],
      exports = ["@org_apache_logging_log4j_log4j_to_slf4j//jar"],
      runtime_deps = [
          ":org_apache_logging_log4j_log4j_api",
          ":org_slf4j_slf4j_api",
      ],
  )


  native.java_library(
      name = "org_springframework_boot_spring_boot_test_autoconfigure",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_boot_spring_boot_test_autoconfigure//jar"],
      runtime_deps = [
          ":org_springframework_boot_spring_boot_autoconfigure",
          ":org_springframework_boot_spring_boot_test",
      ],
  )


  native.java_library(
      name = "org_xmlunit_xmlunit_core",
      visibility = ["//visibility:public"],
      exports = ["@org_xmlunit_xmlunit_core//jar"],
  )


  native.java_library(
      name = "org_apache_logging_log4j_log4j_api",
      visibility = ["//visibility:public"],
      exports = ["@org_apache_logging_log4j_log4j_api//jar"],
  )


  native.java_library(
      name = "org_springframework_boot_spring_boot_starter_logging",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_boot_spring_boot_starter_logging//jar"],
      runtime_deps = [
          ":ch_qos_logback_logback_classic",
          ":ch_qos_logback_logback_core",
          ":org_apache_logging_log4j_log4j_api",
          ":org_apache_logging_log4j_log4j_to_slf4j",
          ":org_slf4j_jul_to_slf4j",
          ":org_slf4j_slf4j_api",
      ],
  )


  native.java_library(
      name = "ch_qos_logback_logback_core",
      visibility = ["//visibility:public"],
      exports = ["@ch_qos_logback_logback_core//jar"],
  )


  native.java_library(
      name = "net_minidev_json_smart",
      visibility = ["//visibility:public"],
      exports = ["@net_minidev_json_smart//jar"],
      runtime_deps = [
          ":net_minidev_accessors_smart",
          ":org_ow2_asm_asm",
      ],
  )


  native.java_library(
      name = "net_bytebuddy_byte_buddy",
      visibility = ["//visibility:public"],
      exports = ["@net_bytebuddy_byte_buddy//jar"],
  )


  native.java_library(
      name = "org_springframework_boot_spring_boot",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_boot_spring_boot//jar"],
      runtime_deps = [
          ":org_springframework_spring_aop",
          ":org_springframework_spring_beans",
          ":org_springframework_spring_context",
          ":org_springframework_spring_core",
          ":org_springframework_spring_expression",
          ":org_springframework_spring_jcl",
      ],
  )


  native.java_library(
      name = "com_fasterxml_jackson_module_jackson_module_parameter_names",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_jackson_module_jackson_module_parameter_names//jar"],
      runtime_deps = [
          ":com_fasterxml_jackson_core_jackson_core",
          ":com_fasterxml_jackson_core_jackson_databind",
      ],
  )


  native.java_library(
      name = "org_hamcrest_hamcrest_library",
      visibility = ["//visibility:public"],
      exports = ["@org_hamcrest_hamcrest_library//jar"],
      runtime_deps = [
          ":org_hamcrest_hamcrest_core",
      ],
  )


  native.java_library(
      name = "org_springframework_boot_spring_boot_starter_tomcat",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_boot_spring_boot_starter_tomcat//jar"],
      runtime_deps = [
          ":javax_annotation_javax_annotation_api",
          ":org_apache_tomcat_embed_tomcat_embed_core",
          ":org_apache_tomcat_embed_tomcat_embed_el",
          ":org_apache_tomcat_embed_tomcat_embed_websocket",
      ],
  )


  native.java_library(
      name = "junit_junit",
      visibility = ["//visibility:public"],
      exports = ["@junit_junit//jar"],
      runtime_deps = [
          ":org_hamcrest_hamcrest_core",
      ],
  )


  native.java_library(
      name = "net_minidev_accessors_smart",
      visibility = ["//visibility:public"],
      exports = ["@net_minidev_accessors_smart//jar"],
      runtime_deps = [
          ":org_ow2_asm_asm",
      ],
  )


  native.java_library(
      name = "org_slf4j_slf4j_api",
      visibility = ["//visibility:public"],
      exports = ["@org_slf4j_slf4j_api//jar"],
  )


  native.java_library(
      name = "org_apache_tomcat_embed_tomcat_embed_core",
      visibility = ["//visibility:public"],
      exports = ["@org_apache_tomcat_embed_tomcat_embed_core//jar"],
  )


  native.java_library(
      name = "org_springframework_boot_spring_boot_autoconfigure",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_boot_spring_boot_autoconfigure//jar"],
      runtime_deps = [
          ":org_springframework_boot_spring_boot",
      ],
  )


  native.java_library(
      name = "com_fasterxml_jackson_core_jackson_annotations",
      visibility = ["//visibility:public"],
      exports = ["@com_fasterxml_jackson_core_jackson_annotations//jar"],
  )


  native.java_library(
      name = "org_springframework_spring_web",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_spring_web//jar"],
      runtime_deps = [
          ":org_springframework_spring_beans",
          ":org_springframework_spring_core",
      ],
  )


  native.java_library(
      name = "org_springframework_spring_jcl",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_spring_jcl//jar"],
  )


  native.java_library(
      name = "org_springframework_spring_beans",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_spring_beans//jar"],
      runtime_deps = [
          ":org_springframework_spring_core",
      ],
  )


  native.java_library(
      name = "org_springframework_spring_webmvc",
      visibility = ["//visibility:public"],
      exports = ["@org_springframework_spring_webmvc//jar"],
      runtime_deps = [
          ":org_springframework_spring_aop",
          ":org_springframework_spring_beans",
          ":org_springframework_spring_context",
          ":org_springframework_spring_core",
          ":org_springframework_spring_expression",
          ":org_springframework_spring_web",
      ],
  )


  native.java_library(
      name = "org_yaml_snakeyaml",
      visibility = ["//visibility:public"],
      exports = ["@org_yaml_snakeyaml//jar"],
  )


