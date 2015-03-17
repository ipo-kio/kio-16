package kio.logs;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class RecordExtractor implements LogParserHandler {

    public static final Pattern RECORD_PATTERN = Pattern.compile("([a-zA-Z0-9_-]+): New record!");
    public static final ObjectMapper mapper = new ObjectMapper();
    public static final JsonFactory factory = mapper.getFactory();

    private final RecordHandler handler;

    public RecordExtractor(RecordHandler handler) {
        this.handler = handler;
    }

    @Override
    public void handleSubLog(String logId, MachineInfo info) {
        //do nothing
    }

    @Override
    public void handleCommand(long time, String cmd, Object[] extraArgs) {
        if (extraArgs.length != 2)
            return;

        Matcher m = RECORD_PATTERN.matcher(cmd);
        if (!m.matches())
            return;

        String pid = m.group(1);
        String solutionAsString = String.valueOf(extraArgs[0]);
        String resultAsString = String.valueOf(extraArgs[1]);

        try {
            JsonNode solution = factory.createParser(solutionAsString).readValueAsTree();
            JsonNode result = factory.createParser(resultAsString).readValueAsTree();
            if (solution.isObject() && result.isObject())
                handler.handleRecord(pid, (ObjectNode)solution, (ObjectNode)result);
        } catch (IOException e) {
            //failed to parse
        }
    }
}
