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

package com.example;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;

@RunWith(SpringRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
public class TodoControllerTest {

  @Autowired private MockMvc mockMvc;

  @Test
  public void noParamTodoShouldReturnDefaultTask() throws Exception {

    this.mockMvc
        .perform(get("/todos"))
        .andDo(print())
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.title").value("A task"))
        .andExpect(jsonPath("$.description").value("Task details"));
  }

  @Test
  public void paramTodoShouldReturnTailoredTask() throws Exception {

    this.mockMvc
        .perform(
            get("/todos")
                .param("title", "Change laundry")
                .param("description", "Put the wet clothes in the dryer"))
        .andDo(print())
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.title").value("Change laundry"))
        .andExpect(jsonPath("$.description").value("Put the wet clothes in the dryer"));
  }
}
