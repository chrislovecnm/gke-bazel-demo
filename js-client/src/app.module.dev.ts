
import {NgModule, NgModuleFactoryLoader} from '@angular/core';

import {routes} from './app-routing.module';
import {AppComponent} from './app.component';
import {AppModule} from './app.module';
import {AppRoutingModule} from './app-routing.module';
import {HelloWorldModuleNgFactory} from './hello-world/hello-world.module.ngfactory';
import {TodosModuleNgFactory} from './todos/todos.module.ngfactory';


const routeModule = {
  todos: TodosModuleNgFactory,
  'hello-world': HelloWorldModuleNgFactory,
};

const map = routes.reduce((a, r) => {
  a[r.loadChildren as string] = routeModule[r.path];
  return a;
}, {})


export class MyLoader extends NgModuleFactoryLoader {
  load(id: string) {
    const res = map[id];
    if (!res) {
      throw new Error(`Unrecognized route id ${id}`);
    }
    return Promise.resolve(res);
  }
}

@NgModule({
  imports: [AppModule],
  bootstrap: [AppComponent],
  providers: [{provide: NgModuleFactoryLoader, useClass: MyLoader}]
})
export class AppModuleDev {}
