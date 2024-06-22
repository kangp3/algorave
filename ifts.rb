ROOT_DIR = "/Users/kangp3/Documents/projects/algorave"

use_bpm 120

define :trumpet do |note, sustain=0.5, amp=0.3|
  use_synth :saw
  
  notes = []
  notes << play(note, amp: amp, attack: 0.1, sustain: sustain, decay: 0.1, release: 0.1, note_slide: 2.0, amp_slide: 2.0)
  notes << play(note + 12, amp: amp * 0.2, attack: 0.1, sustain: sustain, decay: 0.1, release: 0.1, note_slide: 2.0, amp_slide: 2.0)
  notes << play(note + 19, amp: amp * 0.05, attack: 0.1, sustain: sustain, decay: 0.1, release: 0.1, note_slide: 2.0, amp_slide: 2.0)
  notes << play(note + 24, amp: amp * 0.01, attack: 0.1, sustain: sustain, decay: 0.1, release: 0.1, note_slide: 2.0, amp_slide: 2.0)
  return notes
end

define :play_notes do |notes, durations|
  notes.zip(durations).each do |notey, d|
    if notey.is_a? Array
      notey.each do |n|
        trumpet n
      end
    else
      trumpet notey
    end
    sleep d
  end
end

define :bend_me do
  use_bpm 140
  use_synth :saw
  
  n = play :A1, amp: 0.7, attack: 0, sustain: 20, release: 0, note_slide: 20
  control n, note: :B5
  sleep 20
  cue :y_start
end

define :y_start do
  use_bpm 140
  
  notes =     [:B5, :A5, :E5, :B5, :A5, :D6, :B5,  :B5,  :A5, :E5]
  durations = [1.5, 0.5, 2.5, 0.5, 0.5, 0.25, 0.5, 0.25, 0.5, 1]
  
  play_notes notes, durations
end

define :y_chords do
  use_bpm 140
  
  durations = [ 1.5, 0.25, 0.25, 1.5, 0.25, 0.25]
  notes =     [:G5, [:G5, :D4, :C4], [:G5, :D4, :C4], [:G5, :D4, :C4], [:G5, :D4, :C4], [:G5, :D4, :C4]]
  
  play_notes notes, durations
  cue :y_chord_sustain
end

in_thread do
  use_bpm 140
  
  sync :bend_start
  bend_me
end

live_loop :buzz_em do
  use_bpm 140
  
  use_synth :saw
  
  s = play :A1, amp: 0.7, attack: 0, sustain: 15, decay: 0, release: 0
  sleep 15
  
  ##| cue :bend_start
  ##| sync :dne
end

in_thread do
  use_bpm 140
  
  sync :y_start
  y_start
  y_start
  y_chords
end

in_thread do
  use_bpm 140
  
  sync :y_chord_sustain
  
  live_loop :cd_sustain do
    chd = [:G5, :D4, :C4, :G3, :D2, :C2, :C1]
    chd.each do |note|
      trumpet note, 12
    end
    sleep 12
    
    4.times do
      chd.each do |note|
        trumpet note, 0.1
      end
      sleep 0.25
    end
    chd.each do |note|
      trumpet note, 0.3
    end
    sleep 0.5
    6.times do
      chd.each do |note|
        trumpet note, 0.1
      end
      sleep 0.25
    end
    chd.each do |note|
      trumpet note, 0.3
    end
    sleep 0.5
    6.times do
      chd.each do |note|
        trumpet note+5, 0.1
      end
      sleep 0.25
    end
    chd.each do |note|
      trumpet note+5, 0.3
    end
    sleep 0.5
    6.times do
      chd.each do |note|
        trumpet note+3, 0.1
      end
      sleep 0.25
    end
    chd.each do |note|
      trumpet note+3, 0.3
    end
    sleep 0.5
    2.times do
      chd.each do |note|
        trumpet note-2, 0.1
      end
      sleep 0.25
    end
    4.times do
      chd.each do |note|
        trumpet note, 0.1
      end
      sleep 0.25
    end
    
    sustained = []
    chd.each do |n|
      sustained.push(*(trumpet n, 24))
    end
    sleep 12
    
    sustained.zip(chd).each do |playing, n|
      control playing, amp: 0, note: 0
    end
    
    sleep 4
    
    cue :put_the_kick_on_the_20ft_track
    sync :dne
  end
end

live_loop :backbeat, sync: :put_the_kick_on_the_20ft_track do
  use_bpm 120
  
  ##| cue :start_melod
  
  in_thread do
    ##| sample "#{ROOT_DIR}/fatbeat.wav", amp: 8
  end
  
  in_thread do
    ##| sleep 0.5
    ##| sample :hat_psych
  end
  
  in_thread do
    ##| use_synth :sc808_clap
    ##| sleep 0.5
    ##| play :C, amp: 2
  end
  
  in_thread do
    ##| sample "#{ROOT_DIR}/ym.wav"
    ##| sleep 4
  end
  
  in_thread do
    ##| sleep 0.5
    ##| sample "#{ROOT_DIR}/iftsat.wav", rate: 0.98
  end
  
  in_thread do
    ##| sleep 3.5
    ##| sample "#{ROOT_DIR}/ifts.wav", rate: 0.98
    ##| sleep 2
  end
  
  in_thread do
    ##| sleep 0.8
    ##| sample "#{ROOT_DIR}/sat.wav", rate: 0.98
    ##| sleep 1
  end
  
  in_thread do
    ##| sleep 0.3
    ##| sample "#{ROOT_DIR}/stay.wav", rate: 0.98
    ##| sleep 8
  end
  
  ##| sample :glitch_bass_g, rate: 0.3, amp: 3, rpitch: 4
  ##| sample :glitch_bass_g, rate: 0.3, amp: 3, rpitch: 2
  ##| loop do
  ##|   use_bpm_mul 0.8
  ##|   sleep 1
  ##| end
  
  sample :drum_bass_hard, rpitch: 1.01
  sample :drum_bass_hard, rpitch: 0.1, amp: 2
  sleep 1
  3.times do
    sample :drum_bass_hard
    sample :drum_bass_hard, rpitch: 0.1, amp: 1.5
    sleep 1
  end
end

live_loop :bg_melod, sync: :start_melod do
  use_synth :dpulse
  play :C3, sustain: 3.5, amp: 0.2
  sleep 3.5
  play :C3 + 5, sustain: 1.5, amp: 0.2
  sleep 2
  play :C3 + 4, sustain: 1.5, amp: 0.2
  sleep 2
  play :C3 - 2, amp: 0.2
  sleep 0.5
end

