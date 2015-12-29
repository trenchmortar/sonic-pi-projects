set_volume! 5
use_random_seed Time.now.usec

# a = 0
# fadeout = false
# # tick_set 0.00
#   # autosync(:drn)
#   if a <= 0.10 && fadeout == false#0.1
#     a += 0.01
#     puts a
#   else# a >= 0.1 && fadeout == true
#     fadeout = true
#     while a > 0
#       a -= 0.01
#       puts a
#     end
#     puts "fadeout"
#     #   tick_reset
#     #   a = tick * -0.01

#   end

live_loop :origin_untraceable do
  use_synth :dark_ambience

  scl = scale([:c5, :c6].choose, :harmonic_minor, num_octaves: 2)
  notes = mk_rand_scale(scl, 8)
  sprd1 = [3,5,6].choose
  4.times do
    notes.size.times do
      if (spread sprd1, 8)
        play note notes.tick
      end
      sleep 0.25#[0.125, 0.25, 0.5].choose
    end
  end
  if one_in 2
    sleep [2,4,8].choose
  end
  4.times do
    notes.size.times do
      if (spread sprd1, 8)
        play note notes.tick
      end
      sleep 0.25#[0.125, 0.25, 0.5].choose
    end
  end
  sleep [8,16].choose
end

live_loop :fourfour do
  if one_in 5
    sleep [8, 16].choose
  else
    8.times do
      sample :bd_haus, amp: 1, cutoff: 75, rate: 0.9
      sleep 0.5
    end
  end
end

live_loop :looper do
  if one_in 5
    sleep [8, 16].choose
  else
    4.times do
      sample :loop_breakbeat, beat_stretch: 2, amp: 0.5
      sleep 2
    end
  end
end

live_loop :offbass do

  notes = [:c2, :ds2, :c2].ring
  use_synth :subpulse
  if one_in 5
    sleep [16, 32].choose
  else
    notes.size.times do
      tick
      16.times do
        sleep 0.25
        play notes.look, release: 0.25, amp: 0.7, cutoff: 85, res: 0.1
        sleep 0.25
      end
    end
  end
end

live_loop :crystal_entity do
  notes = (ring 60, 62, 63, 65, 68, 71, 72).shuffle

  vol = 0.8

  frq = midi_to_hz(notes.tick)
  # with_fx :ring_mod, freq: frq do
  if not one_in 5
    sample :loop_mika, beat_stretch: 16, amp: 0.4
  end
  sleep 16
  # end
  # end
end



max_t = 3
cue :pulse

live_loop :bitstream do
  # use_synth :growl
  use_synth :dpulse

  autosync(:pulse)
  autostop(rrand max_t*0.65, max_t) # (rrand_i 5, 8)
  puts "Bitstream"

  # notes = (knit :c2, 2, :ds2, 1, :c2, 1)
  notes = (chord :c2, :minor)
  if one_in 5
    sleep [16,32].choose
  else
    with_fx :bitcrusher, mix: 0.4, bits: [5, 6].choose, sample_rate: (range 500, 3000, step: 250, inclusive: true).choose do
      with_fx :slicer, phase: 0.125, smooth_up: 0.01, smooth_down: 0.01 do

        with_fx :reverb, mix: 0.3, room: 0.4, amp: 1 do
          notes.size.times do
            # cut = [55, 60, 65, 70, 75, 80, 85, 80, 75, 70, 65, 60].ring
            cut = (range 50, 110, step: 10, inclusive: true)
            cut2 = (range 110, 50, step: 10, inclusive: true)

            s = play notes.tick, note_slide: 0.5, amp: 0.3, attack: 0.1, sustain: 8, release: 0.1, cutoff: cut.look(:cut), cutoff_slide: 4, res: 0.2
            control s, cutoff: cut2.look(:cut)
            sleep 4
            control s, cutoff: cut.tick(:cut)
            sleep 3.5
            control s, note: notes.tick
            sleep 0.5
          end
        end
      end
    end
  end
end
