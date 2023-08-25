// ignore_for_file: constant_identifier_names

enum CharacterSpecies { human, alien, empty }

enum CharacterStatus { alive, unknown, dead, empty }

enum CharacterGender { male, female, unknown, empty }

class CharacterItems {
  String name;
  CharacterSpecies species;
  CharacterGender gender;
  CharacterStatus status;

  CharacterItems(
      {required this.name,
      required this.species,
      required this.gender,
      required this.status});
  CharacterItems.empty()
      : this(
            gender: CharacterGender.empty,
            name: "",
            species: CharacterSpecies.empty,
            status: CharacterStatus.empty);
}

final characterSpeciesValues = <CharacterSpecies, String>{
  CharacterSpecies.alien: "Alien",
  CharacterSpecies.human: "Human",
  CharacterSpecies.empty: "",
};

final characterStatusValues = <CharacterStatus, String>{
  CharacterStatus.alive: "Alive",
  CharacterStatus.dead: "Dead",
  CharacterStatus.unknown: "unknown",
  CharacterStatus.empty: "",
};

final characterGenderValues = <CharacterGender, String>{
  CharacterGender.female: "Female",
  CharacterGender.male: "Male",
  CharacterGender.unknown: "unknown",
  CharacterGender.empty: "",
};

class LocationItems {
  String name;
  String dimension;

  LocationItems({required this.name, required this.dimension});
  LocationItems.empty() : this(name: "", dimension: "");
}

enum SeasonNumber { empty, S01, S02, S03, S04, S05 }

List<SeasonNumber> s = SeasonNumber.values;

enum EpisodeNumber {
  empty,
  E01,
  E02,
  E03,
  E04,
  E05,
  E06,
  E07,
  E08,
  E09,
  E10,
  E11;
}

final seasonString = <SeasonNumber, String>{
  SeasonNumber.empty: "",
  SeasonNumber.S01: "S01",
  SeasonNumber.S02: "S02",
  SeasonNumber.S03: "S03",
  SeasonNumber.S04: "S04",
  SeasonNumber.S05: "S05"
};

List<EpisodeNumber> episodeList = [
  EpisodeNumber.E01,
  EpisodeNumber.E02,
  EpisodeNumber.E03,
  EpisodeNumber.E04,
  EpisodeNumber.E05,
  EpisodeNumber.E06,
  EpisodeNumber.E07,
  EpisodeNumber.E08,
  EpisodeNumber.E09,
  EpisodeNumber.E10,
];

var seasonEpisode = <SeasonNumber, List<EpisodeNumber>>{
  SeasonNumber.empty: [],
  SeasonNumber.S01: [...episodeList, EpisodeNumber.E11],
  SeasonNumber.S02: episodeList,
  SeasonNumber.S03: episodeList,
  SeasonNumber.S04: episodeList,
  SeasonNumber.S05: episodeList,
};

Map<SeasonNumber, List<EpisodeNumber>> selectedEpisode = {
  SeasonNumber.empty: [],
  SeasonNumber.S01: [],
  SeasonNumber.S02: [],
  SeasonNumber.S03: [],
  SeasonNumber.S04: [],
  SeasonNumber.S05: []
};

class EpisodeItems {
  SeasonNumber season;
  EpisodeNumber episode;
  List<EpisodeItems> selectedEpisode = <EpisodeItems>[];
  bool isSelected = false;

  EpisodeItems.empty()
      : this(episode: EpisodeNumber.empty, season: SeasonNumber.empty);
  EpisodeItems({required this.episode, required this.season});
}
