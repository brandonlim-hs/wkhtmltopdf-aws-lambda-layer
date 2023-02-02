package example;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.amazonaws.services.lambda.runtime.Context;

public class Example {
    public void handleRequest(Object input, Context context) throws Exception {
        List<List<String>> commands = new ArrayList<List<String>>();
        commands.add(Arrays.asList("ldd", "/opt/bin/wkhtmltopdf"));
        commands.add(Arrays.asList("wkhtmltopdf", "-V"));

        ProcessBuilder builder = new ProcessBuilder();
        builder.inheritIO();
        for (List<String> command : commands) {
            builder.command(command);
            Process process = builder.start();
            if (process.waitFor() != 0) {
                throw new Exception(String.format("Command failed: %s", command.toString()));
            }
        }
    }
}