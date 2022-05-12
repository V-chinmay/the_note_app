enum EndpointType { getAllNotes, deleteNoteByID, updateNote, getNoteDetailByID }

abstract class Endpoints {
  static Map<EndpointType, String> endpointMap = {
    EndpointType.getAllNotes: "dev/notes",
    EndpointType.getNoteDetailByID: "dev/note/n",
    EndpointType.deleteNoteByID: "dev/note/t",
    EndpointType.updateNote: "dev/note"
  };

  static String get getAlllNotesEndpoint =>
      endpointMap[EndpointType.getAllNotes]!;

  static String get updateNoteEndpoint => endpointMap[EndpointType.updateNote]!;

  static String deleteNoteByIDEndpoint(String noteID) =>
      endpointMap[EndpointType.deleteNoteByID]! + "/$noteID";

  static String getNoteDetailByIDEndpoint(String noteID) =>
      endpointMap[EndpointType.getNoteDetailByID]! + "/$noteID";
      
}
