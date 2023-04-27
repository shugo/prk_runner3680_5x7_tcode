kbd = Keyboard.new

kbd.split = true

kbd.init_pins(
  [ 4, 5, 6, 7, 8 ],
  [ 28, 27, 26, 22, 20, 23, 21 ]
)

kbd.add_layer :default, %i[
    KC_ESCAPE   KC_GRAVE   KC_1     KC_2     KC_3     KC_4     KC_5         KC_6     KC_7     KC_8     KC_9     KC_0     KC_MINUS  KC_EQUAL
    KC_TAB   KC_TAB   KC_Q     KC_W     KC_E     KC_R     KC_T         KC_Y     KC_U     KC_I     KC_O     KC_P     KC_LBRACKET  KC_RBRACKET
    KC_LCTL  KC_LCTL  KC_A     KC_S     KC_D     KC_F     KC_G         KC_H     KC_J     KC_K     KC_L     KC_SCOLON  KC_QUOTE  KC_BSLASH
    KC_PGUP  KC_LSFT  KC_Z     KC_X     KC_C     KC_V     KC_B         KC_N     KC_M     KC_COMMA  KC_DOT   KC_SLASH  KC_ENTER  KC_RSFT
    KC_PGDOWN  ADJUST   KC_LGUI  KC_LALT  KC_LGUI  LOWER    KC_SPACE       KC_BSPACE  RAISE    KC_INSERT   KC_HOME  KC_END   KC_DELETE   KC_RCTL
]

kbd.add_layer :lower, %i[
    KC_NO    KC_TILD  KC_F1    KC_F2    KC_F3    KC_F4    KC_F5        KC_F6    KC_F7    KC_F8    KC_F9    KC_F10   KC_F11   KC_F12
    KC_UNDS  KC_NO    KC_EXLM  KC_AT    KC_HASH  KC_DLR   KC_PERC      KC_CIRC  KC_AMPR  KC_ASTR  KC_LPRN  KC_RPRN  KC_LCBR  KC_RCBR
    KC_PLUS  KC_LCTL  KC_F1    KC_F2    KC_F3    KC_F4    KC_F5        KC_LEFT  KC_DOWN  KC_UP    KC_RIGHT  KC_F6    KC_NO    KC_NO
    KC_PSCR  KC_LSFT  KC_F7    KC_F8    KC_F9    KC_F10   KC_F11       KC_F12   KC_NO    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO
    KC_SLCK  KC_NO    KC_LGUI  KC_LALT  KC_LGUI  KC_NO    KC_SPACE     KC_BSPACE KC_NO   KC_MNXT  KC_VOLD  KC_VOLU  KC_MPLY  KC_MUTE
]

kbd.add_layer :raise, %i[
    KC_NO    KC_TILD  KC_F1    KC_F2    KC_F3    KC_F4    KC_F5        KC_F6    KC_F7    KC_F8    KC_F9    KC_F10   KC_F11   KC_F12
    KC_UNDS  KC_NO    KC_1     KC_2     KC_3     KC_4     KC_5         KC_6     KC_7     KC_8     KC_9     KC_0     KC_LCBR  KC_RCBR
    KC_PLUS  KC_NO    KC_F1    KC_F2    KC_F3    KC_F4    KC_F5        KC_F6    KC_MINUS  KC_EQUAL   KC_LBRACKET  KC_RBRACKET  KC_NO    KC_NO
    KC_PSCR  KC_NO    KC_F7    KC_F8    KC_F9    KC_F10   KC_F11       KC_F12   KC_NUHS  KC_NUBS  KC_NO    KC_NO    KC_NO    KC_NO
    KC_SLCK  KC_NO    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO        KC_NO    KC_NO    KC_MNXT  KC_VOLD  KC_VOLU  KC_MPLY  KC_MUTE
]

kbd.add_layer :adjust, %i[
    KC_NO    KC_F1    KC_F2    KC_F3    KC_F4    KC_F5    KC_F6        KC_F7    KC_F8    KC_F9    KC_F10   KC_F11   KC_F12   KC_NO
    KC_NO    KC_NO    RESET    RGB_TOG  RGB_MOD  RGB_HUD  RGB_HUI      RGB_SAD  RGB_SAI  RGB_VAD  RGB_VAI  KC_NO    KC_DELETE   KC_NO
    KC_NO    KC_NO    KC_NO    KC_NO    AU_ON    AU_OFF   AG_NORM      AG_SWAP  QWERTY   KC_NO    KC_NO    KC_NO    KC_NO    KC_NO
    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO        KC_NO    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO
    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO    KC_TCTG        KC_NO    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO    KC_NO
]

kbd.add_layer :tcode, %i[
    KC_ESCAPE   KC_GRAVE   KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC     KC_TC     KC_TC     KC_MINUS  KC_EQUAL
    KC_TAB   KC_TAB   KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC     KC_TC     KC_TC     KC_LBRACKET  KC_RBRACKET
    KC_LCTL  KC_LCTL  KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC     KC_TC     KC_TC  KC_QUOTE  KC_BSLASH
    KC_PGUP  KC_LSFT  KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC  KC_TC   KC_TC  KC_ENTER  KC_RSFT
    KC_PGDOWN  ADJUST   KC_LGUI  KC_LALT  KC_LGUI  LOWER    KC_SPACE       KC_BSPACE  RAISE    KC_INSERT   KC_HOME  KC_END   KC_DELETE   KC_RCTL
]

kbd.define_mode_key :LOWER, [ :KC_NO, :lower, 0, 0 ]
kbd.define_mode_key :RAISE, [ :KC_NO, :raise, 0, 0 ]
kbd.define_mode_key :ADJUST, [ :KC_NO, :adjust, 0, 0 ]
kbd.define_mode_key :KC_TCTG, [ Proc.new { kbd.default_layer = kbd.default_layer == :default ? :tcode : :default }, nil, 300, nil ]

TCODE_TABLE = TcodeTable.new

class Keyboard
  attr_reader :switches
end

tc_index = nil
prev_tc_index = nil

kbd.before_report do
  if switch = kbd.switches.last
    tc_index = 10 * switch[0] + switch[1] - 2
  end
end

tcode = Proc.new {
  if prev_tc_index
    i = 40 * tc_index + prev_tc_index
    if codepoint = TCODE_TABLE[i]
      kbd.send_key(:KC_LCTL, :KC_LSFT, :KC_U)
      kbd.macro(codepoint + " ", [])
    else
      puts "Undefined char: #{i}"
    end
    prev_tc_index = nil
  else
    prev_tc_index = tc_index
  end
}
kbd.define_mode_key :KC_TC, [ tcode, nil, 300, nil ]

kbd.start!
