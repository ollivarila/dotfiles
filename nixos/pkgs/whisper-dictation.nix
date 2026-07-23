{ pkgs }:
let
  # GTX 1080 is Pascal (sm_61). Forcing CMAKE_CUDA_ARCHITECTURES directly
  # (rather than relying on nixpkgs' config.cudaCapabilities, which doesn't
  # reliably propagate through home-manager's pkgs) also keeps the build to
  # a single arch instead of nixpkgs' default list of ~9.
  whisper-cpp-cuda = (pkgs.whisper-cpp.override { cudaSupport = true; }).overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DCMAKE_CUDA_ARCHITECTURES=61" ];
  });

  # Swap url/sha256 here for a different model size, see
  # https://huggingface.co/ggerganov/whisper.cpp/tree/main.
  whisper-model = pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-medium.en.bin";
    sha256 = "0mj3vbvaiyk5x2ids9zlp2g94a01l4qar9w109qcg3ikg0sfjdyc";
  };

  # Bumped via `pkill -RTMIN+8 waybar` (see waybar/config custom/dictation)
  # so the bar refreshes immediately instead of waiting on a poll interval.
  setDictationState = state: ''
    echo "${state}" > "''${XDG_RUNTIME_DIR:-/tmp}/whisper-dictation-state"
    pkill -RTMIN+8 waybar || true
  '';

  whisper-dictation-start = pkgs.writeShellApplication {
    name = "whisper-dictation-start";
    runtimeInputs = [
      pkgs.pipewire
      pkgs.procps
    ];
    text = ''
      PIDFILE="''${XDG_RUNTIME_DIR:-/tmp}/whisper-dictation.pid"
      WAVFILE="''${XDG_RUNTIME_DIR:-/tmp}/whisper-dictation.wav"

      if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
        exit 0
      fi

      pw-record --rate 16000 --channels 1 --format s16 "$WAVFILE" &
      echo $! > "$PIDFILE"
      disown
      ${setDictationState "recording"}
    '';
  };

  whisper-dictation-stop = pkgs.writeShellApplication {
    name = "whisper-dictation-stop";
    runtimeInputs = [
      whisper-cpp-cuda
      pkgs.pipewire
      pkgs.wtype
      pkgs.procps
    ];
    text = ''
      PIDFILE="''${XDG_RUNTIME_DIR:-/tmp}/whisper-dictation.pid"
      WAVFILE="''${XDG_RUNTIME_DIR:-/tmp}/whisper-dictation.wav"

      if [[ ! -f "$PIDFILE" ]]; then
        ${setDictationState "idle"}
        exit 0
      fi

      kill -INT "$(cat "$PIDFILE")"
      wait "$(cat "$PIDFILE")" 2>/dev/null || true
      rm -f "$PIDFILE"
      ${setDictationState "transcribing"}
      TEXT=$(whisper-cli -m ${whisper-model} -f "$WAVFILE" -nt -np 2>/dev/null)
      wtype "$TEXT"
      rm -f "$WAVFILE"
      ${setDictationState "idle"}
    '';
  };

  whisper-dictation-status = pkgs.writeShellApplication {
    name = "whisper-dictation-status";
    text = ''
      STATE=$(cat "''${XDG_RUNTIME_DIR:-/tmp}/whisper-dictation-state" 2>/dev/null || echo idle)
      case "$STATE" in
        recording)
          echo '{"text":"● Listening","class":"recording"}'
          ;;
        transcribing)
          echo '{"text":"… Transcribing","class":"transcribing"}'
          ;;
        *)
          echo '{"text":"","class":"idle"}'
          ;;
      esac
    '';
  };
in
{
  inherit
    whisper-model
    whisper-dictation-start
    whisper-dictation-stop
    whisper-dictation-status
    ;
}
