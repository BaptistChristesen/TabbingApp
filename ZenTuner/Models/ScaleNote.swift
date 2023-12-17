import Darwin.C.math
import SwiftUI
/// A note in a twelve-tone equal temperament scale. https://en.wikipedia.org/wiki/Equal_temperament
enum ScaleNote: Int, CaseIterable, Identifiable {
    case E2, F2, FS2, G2, GS2, A2, AS2, B2, C3, CS3, D3, DS3, E3, F3, FS3, G3, GS3, A3, AS3, B3, C4, CS4, D4, DS4, E4, F4, FS4, G4, GS4, A4, AS4, B4, C5, CS5, D5, DS5, E5, F5
    var id: Int { rawValue }
    struct Match: Hashable {
        let note: ScaleNote
        let octave: Int
        let distance: Frequency.MusicalDistance
        var frequency: Frequency { note.frequency.shifted(byOctaves: octave) }
        func inTransposition(_ transposition: ScaleNote) -> ScaleNote.Match {
            let transpositionDistanceFromC = transposition.rawValue
            guard transpositionDistanceFromC > 0 else {
                return self
            }
            let currentNoteIndex = note.rawValue
            let allNotes = ScaleNote.allCases
            let noteOffset = (allNotes.count - transpositionDistanceFromC) + currentNoteIndex
            let transposedNoteIndex = noteOffset % allNotes.count
            let transposedNote = allNotes[transposedNoteIndex]
            let octaveShift = (noteOffset > allNotes.count - 1) ? 1 : 0
            return ScaleNote.Match(
                note: transposedNote,
                octave: octave + octaveShift,
                distance: distance
            )
        }
    }
    static func closestNote(to frequency: Frequency) -> Match {
        // Shift frequency octave to be within range of scale note frequencies.
        var octaveShiftedFrequency = frequency
        while octaveShiftedFrequency > allCases.last!.frequency {
            octaveShiftedFrequency.shift(byOctaves: -1)
        }
        while octaveShiftedFrequency < allCases.first!.frequency {
            octaveShiftedFrequency.shift(byOctaves: 1)
        }
        // Find closest note
        let closestNote = allCases.min(by: { note1, note2 in
            fabsf(note1.frequency.distance(to: octaveShiftedFrequency).cents) <
                fabsf(note2.frequency.distance(to: octaveShiftedFrequency).cents)
        })!
        let octave = max(octaveShiftedFrequency.distanceInOctaves(to: frequency), 0)
        let fastResult = Match(
            note: closestNote,
            octave: octave,
            distance: closestNote.frequency.distance(to: octaveShiftedFrequency)
        )
        return fastResult
    }
    //ok so like i gotta make these JUST strongs and then basically i gotta change iot from note names to the tabs
    var names: String {
        switch self {
        case .E2:
            "-\n-\n-\n2\n2\n0"
        case .F2:
            "-\n-\n-\n3\n3\n1"
        case .FS2:
            "-\n-\n-\n4\n4\n2"
        case .G2:
            "-\n-\n-\n5\n5\n3"
        case .GS2:
            "-\n-\n-\n6\n6\n4"
        case .A2:
            "-\n-\n-\n7\n7\n5"
        case .AS2:
            "-\n-\n-\n8\n8\n6"
        case .B2:
            "-\n-\n-\n9\n9\n7"
        case .C3:
            "-\n-\n-\n10\n10\n8"
        case .CS3:
            "-\n-\n-\n11\n11\n9"
        case .D3:
            "-\n-\n-\n12\n12\n10"
        case .DS3:
            "-\n-\n-\n13\n13\n11"
        case .E3:
            "-\n-\n9\n9\n7\n-"
        case .F3:
            "-\n-\n10\n10\n8\n-"
        case .FS3:
            "-\n-\n11\n11\n9\n-"
        case .G3:
            "-\n-\n12\n12\n10\n-"
        case .GS3:
            "-\n-\n13\n13\n11\n-"
        case .A3:
            "-\n9\n9\n7\n-\n-"
        case .AS3:
            "-\n10\n10\n8\n-\n-"
        case .B3:
            "-\n11\n11\n9\n-\n-"
        case .C4:
            "-\n12\n12\n10\n-\n-"
        case .CS4:
            "-\n13\n13\n11\n-\n-"
        case .D4:
            "9\n9\n7\n-\n-\n-"
        case .DS4:
            "10\n10\n8\n-\n-\n-"
        case .E4:
            "11\n11\n9\n-\n-\n-"
        case .F4:
            "12\n12\n10\n-\n-\n-"
        case .FS4:
            "13\n13\n11\n-\n-\n-"
        case .G4:
            "14\n14\n12\n-\n-\n-"
        case .GS4:
            "15\n15\n13\n-\n-\n-"
        case .A4:
            "16\n16\n14\n-\n-\n-"
        case .AS4:
            "17\n17\n15\n-\n-\n-"
        case .B4:
            "18\n18\n16\n-\n-\n-"
        case .C5:
            "19\n19\n17\n-\n-\n-"
        case .CS5:
            "20\n20\n18\n-\n-\n-"
        case .D5:
            "21\n21\n19\n-\n-\n-"
        case .DS5:
            "22\n22\n20\n-\n-\n-"
        case .E5:
            "23\n23\n21\n-\n-\n-"
        case .F5:
            "24\n24\n22\n-\n-\n-"
        
        }
    }
    /// The frequency for this note at the 0th octave in standard pitch: https://en.wikipedia.org/wiki/Standard_pitch
    var frequency: Frequency {
        switch self {
        case .E2: 82.41
        case .F2: 87.31
        case .FS2: 92.50
        case .G2: 98.00
        case .GS2: 102.83
        case .A2: 110.00
        case .AS2: 116.54
        case .B2: 123.47
        case .C3: 130.81
        case .CS3: 138.59
        case .D3: 146.83
        case .DS3: 155.56
        case .E3:
            164.81
        case .F3:
            174.61
        case .FS3:
            185.00
        case .G3:
            196.00
        case .GS3:
            207.65
        case .A3:
            220.00
        case .AS3:
            233.08
        case .B3:
            246.94
        case .C4:
            261.63
        case .CS4:
            277.18
        case .D4:
            293.66
        case .DS4:
            311.13
        case .E4:
            329.63
        case .F4:
            349.23
        case .FS4:
            369.99
        case .G4:
            392.00
        case .GS4:
            415.30
        case .A4:
            440.00
        case .AS4:
            466.16
        case .B4:
            493.88
        case .C5:
            523.25
        case .CS5:
            554.37
        case .D5:
            587.33
        case .DS5:
            622.25
        case .E5:
            659.25
        case .F5:
            698.46
        }
    }
}
