package se.bjurr.gradle.examples.binaryplugin;

import org.gradle.api.Plugin;
import org.gradle.api.Project;

public class ExampleBinaryPluginGradlePlugin implements Plugin<Project> {
  @Override
  public void apply(Project target) {
    target.getExtensions().create("exampleBinaryPlugin", ExampleBinaryPluginExtension.class);
    target
        .getTasks()
        .register(
            "exampleBinaryPluginTask",
            ExampleBinaryPluginTask.class,
            task -> {
              task.setDescription("Descr.");
              task.setGroup("Examples");
            });
  }
}
