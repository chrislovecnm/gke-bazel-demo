// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


// The function exported from this file is used by the protractor_web_test_suite.
// It is passed to the `onPrepare` configuration setting in protractor and executed
// before running tests.
//
// If the function returns a promise, as it does here, protractor will wait
// for the promise to resolve before running tests.

const protractorUtils = require('@angular/bazel/protractor-utils');
const protractor = require('protractor');

module.exports = function(config) {
  // In this example, `@angular/bazel/protractor-utils` is used to run
  // the server. protractorUtils.runServer() runs the server on a randomly
  // selected port (given a port flag to pass to the server as an argument).
  // The port used is returned in serverSpec and the protractor serverUrl
  // is the configured.
  const portFlag = config.server.endsWith('prodserver') ? '-p' : '-port';
  return protractorUtils.runServer(config.workspace, config.server, portFlag, [])
      .then(serverSpec => {
        const serverUrl = `http://localhost:${serverSpec.port}`;
        protractor.browser.baseUrl = serverUrl;
      });
};
