package se.bjurr.gradle.examples.binaryplugin;

import org.gradle.api.DefaultTask;
import org.gradle.api.logging.LogLevel;
import org.gradle.api.tasks.TaskAction;

public class ExampleBinaryPluginTask extends DefaultTask {

  @TaskAction
  public void theTaskAction() throws Exception {
    getProject().getLogger().log(LogLevel.LIFECYCLE, "\n\n *** Hello from task ***\n\n");
    getProject().getTasks().getByName("build").dependsOn("ExampleBinaryPluginTask");
  }
}
