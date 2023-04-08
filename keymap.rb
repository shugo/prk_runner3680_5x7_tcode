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
    KC_PGDOWN  TOGGLE_TC   KC_LGUI  KC_LALT  KC_LGUI  LOWER    KC_SPACE       KC_BSPACE  RAISE    KC_INSERT   KC_HOME  KC_END   KC_DELETE   KC_RCTL
]

kbd.add_layer :tcode, %i[
    KC_ESCAPE   KC_GRAVE   KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC     KC_TC     KC_TC     KC_MINUS  KC_EQUAL
    KC_TAB   KC_TAB   KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC     KC_TC     KC_TC     KC_LBRACKET  KC_RBRACKET
    KC_LCTL  KC_LCTL  KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC     KC_TC     KC_TC  KC_QUOTE  KC_BSLASH
    KC_PGUP  KC_LSFT  KC_TC     KC_TC     KC_TC     KC_TC     KC_TC         KC_TC     KC_TC     KC_TC  KC_TC   KC_TC  KC_ENTER  KC_RSFT
    KC_PGDOWN  TOGGLE_TC   KC_LGUI  KC_LALT  KC_LGUI  LOWER    KC_SPACE       KC_BSPACE  RAISE    KC_INSERT   KC_HOME  KC_END   KC_DELETE   KC_RCTL
]

kbd.define_mode_key :TOGGLE_TC, [ Proc.new { kbd.default_layer = kbd.default_layer == :default ? :tcode : :default }, nil, 300, nil ]

class Keyboard
  attr_reader :switches
end

tc_index = nil

kbd.before_report do
  if switch = kbd.switches.last
    tc_index = 10 * switch[0] + switch[1] - 2
  end
end

tcode = Proc.new {
  PicoRubyVM.print_alloc_stats
  kbd.switches
  if tc_index
    puts tc_index
  else
    puts "no key"
  end
#  kbd.send_key([("KC_" + kbd.switches.last[0].to_s).intern])
}
kbd.define_mode_key :KC_TC, [ tcode, nil, 300, nil ]
kbd.start!
