module HasNavigationalStatus
  extend ActiveSupport::Concern

  included do
    enum navigational_status: {
      "Under way using engine": 0,
      "At anchor": 1,
      "Not under command": 2,
      "Restricted manoeuverability": 3,
      "Constrained by her draught": 4,
      "Moored": 5,
      "Aground": 6,
      "Engaged in Fishing": 7,
      "Under way sailing": 8,
      "Reserved for future use (9)": 9,
      "Reserved for future use (10)": 10,
      "Reserved for future use (11)": 11,
      "Reserved for future use (12)": 12,
      "Not defined (13)": 13,
      "AIS-SART active": 14,
      "Not defined (15)": 15,
    }
  end
end
