package hello;

import java.util.concurrent.atomic.AtomicLong;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TodoController {

    private final AtomicLong counter = new AtomicLong();

    @GetMapping("/todos")
    public Todo[] list_todos(@RequestParam(value="title", defaultValue="A task") String title,
      @RequestParam(value="description", defaultValue="Task details") String description) {
        Todo todos[] = {new Todo(counter.incrementAndGet(),
                            title, description)};
        return todos;
    }

    @PostMapping("/todos")
    public Todo create_todo(@RequestParam(value="title", defaultValue="A task") String title,
      @RequestParam(value="description", defaultValue="Task details") String description) {
        return new Todo(counter.incrementAndGet(),
                            title, description);
    }

    @PutMapping("/todos")
    public Todo update_todo(@RequestParam(value="id") long id,
      @RequestParam(value="title", defaultValue="A task") String title,
      @RequestParam(value="description", defaultValue="Task details") String description) {
        return new Todo(id, title, description);
    }
}
