module ApplicationHelper
  # Clinic facts (from the approved content document) — single source of truth.
  CLINIC_PHONE_DISPLAY = "+966 58 377 7871"
  CLINIC_PHONE_TEL     = "tel:+966583777871"
  CLINIC_WHATSAPP_URL  = "https://wa.me/966583777871"
  CLINIC_EMAIL         = "dr.balhareth@hotmail.com"
  CLINIC_HOURS_SHORT   = "Sat 9:00 AM–12:00 PM · Sun, Tue, Wed 4:00–8:00 PM"
  CLINIC_LOCATION      = "Riyadh, Saudi Arabia — Dr. Sulaiman Al Habib Medical Group, Al Hamra Hospital"
  CLINIC_MAP_QUERY     = "Dr. Sulaiman Al Habib Al Hamra Hospital Riyadh"
  CLINIC_MAP_EMBED     = "https://maps.google.com/maps?q=#{ERB::Util.url_encode(CLINIC_MAP_QUERY)}&z=15&hl=en&output=embed"
  CLINIC_MAP_LINK      = "https://www.google.com/maps?q=#{ERB::Util.url_encode(CLINIC_MAP_QUERY)}"

  def page_title
    base = "Dr. Mohammed Ali Balhareth — Hip & Knee Replacement and Trauma Surgery, Riyadh"
    t = content_for(:title)
    t.present? ? "#{t} · Dr. Balhareth" : base
  end

  def nav_link_class(path)
    active = (path == root_path) ? current_page?(root_path) : request.path.start_with?(path)
    "nav-link#{' nav-on' if active}"
  end
end
