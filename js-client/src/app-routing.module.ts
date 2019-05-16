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

import {NgModule} from '@angular/core';
import {PreloadAllModules, RouterModule, Routes} from '@angular/router';

// These are lazy-loaded routes - note that we don't import the modules here
// to avoid having an eager dependency on them.
const routes: Routes = [
  {
    path: 'hello',
    pathMatch: 'full',
    loadChildren:  import('./hello-world/hello-world.module.ngfactory').then(m => m.HelloWorldModuleNgFactory)
  },
  {
    path: 'todos',
    pathMatch: 'full',
    loadChildren: () => import('./todos/todos.module.ngfactory').then(m => m.TodosModuleNgFactory)
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes, {
    // TODO: maybe set this based on devmode?
    enableTracing: true,
    // preloadingStrategy: PreloadAllModules,
  })],
  exports: [RouterModule],
})

export class AppRoutingModule {
}
