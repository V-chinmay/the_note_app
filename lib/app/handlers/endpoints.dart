enum EndpointType { getAllNotes, deleteNoteByID, updateNote, getNoteDetailByID }

abstract class Endpoints {
  static String baseURL =
      "https://e9i387iwne.execute-api.us-east-1.amazonaws.com";

  static Map<EndpointType, String> endpointMap = {
    EndpointType.getAllNotes: "/dev/notes",
    EndpointType.getNoteDetailByID: "/dev/note/n",
    EndpointType.deleteNoteByID: "/dev/note/t",
    EndpointType.updateNote: "/dev/note"
  };

  static String get getAlllNotesEndpoint =>
      endpointMap[EndpointType.getAllNotes]!;

  static String get updateNoteEndpoint => endpointMap[EndpointType.updateNote]!;

  static String deleteNoteByTimestamp(int timeStamp) =>
      endpointMap[EndpointType.deleteNoteByID]! + "/$timeStamp";


  static String getNoteDetailByIDEndpoint(String noteID) =>
      endpointMap[EndpointType.getNoteDetailByID]! + "/$noteID";
}
