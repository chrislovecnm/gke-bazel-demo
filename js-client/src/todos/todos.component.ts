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

import {Component, OnInit} from '@angular/core';
import {Observable} from 'rxjs';

import {Todo} from './todo';
import {TodosService} from './todos.service';

@Component({
  selector: 'todos',
  templateUrl: './todos.component.html',
  providers: [TodosService],
  styleUrls: ['./todos.component.css']
})
export class TodosComponent implements OnInit {
  todos: Todo[];
  title: string;
  idToEdit: string|null;
  editing = false;

  constructor(private todosService: TodosService) {}

  ngOnInit() {
    this.getTodos();
  }

  getTodos(): void {
    this.todosService.getTodos().subscribe(todos => this.todos = todos);
  }

  addTodo(title) {
    title = title.trim();
    if (!title) {
      return;
    }

    const newTodo: Todo = {title} as Todo;
    this.todosService.addTodo(newTodo).subscribe(todo => {
      this.todos.push(todo);
      this.reset();
    });
  }

  deleteTodo(id) {
    this.todosService.deleteTodo(id).subscribe(() => this.getTodos());
  }

  editTodo(todo) {
    this.editing = true;
    this.title = todo.title;
    this.idToEdit = todo.id;
  }

  updateTodo(updatedTitle) {
    const updatedTodo: Todo = {id: this.idToEdit, title: updatedTitle} as Todo;
    this.todosService.updateTodo(updatedTodo).subscribe(() => {
      this.reset();
      this.getTodos();
    });
  }

  cancelEdit() {
    this.reset();
  }

  toggleDone(todo) {
    todo.done = !todo.done;
    this.todosService.updateTodo(todo).subscribe();
  }

  reset() {
    this.idToEdit = null;
    this.editing = false;
    this.title = null;
  }
}
