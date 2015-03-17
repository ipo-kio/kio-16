package kio.logs;

import com.fasterxml.jackson.databind.node.ObjectNode;

public interface RecordHandler {

    void handleRecord(String problemID, ObjectNode solution, ObjectNode result);

}
