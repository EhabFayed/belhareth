# Static content for the four specialty pages. Copy comes from the approved
# site content document (BalHarith Website.pdf, July 2026) — edit here, not in views.
class Condition
  ATTRS = %i[slug num crumb title overview image symptoms conservative surgical when_surgery faq].freeze
  attr_reader(*ATTRS)

  def initialize(attrs)
    ATTRS.each { |a| instance_variable_set("@#{a}", attrs.fetch(a)) }
  end

  def self.all
    ALL
  end

  def self.find(slug)
    ALL.find { |c| c.slug == slug.to_s }
  end

  ALL = [
    new(
      slug: "knee", num: "01", crumb: "KNEE OSTEOARTHRITIS", title: "Knee Osteoarthritis",
      image: "/images/cond-knee.webp",
      overview: "Knee osteoarthritis is the gradual wear of the cartilage cushioning your joint. While it is the most common cause of knee pain after 50, age does not dictate your treatment. What truly matters is the impact on your quality of life and the extent of the joint damage.",
      symptoms: [
        "Pain while walking, using stairs, or standing up",
        "Morning stiffness that improves with activity",
        "Joint swelling following physical activity",
        "A grinding, clicking, or catching sensation in the joint",
        "Gradual difficulty in fully bending or straightening the knee"
      ],
      conservative: [
        "Activity modification and weight management",
        "Physiotherapy and muscle strengthening",
        "Anti-inflammatory medication",
        "Injections — steroid or viscosupplementation"
      ],
      surgical: [
        "Arthroscopic treatment in selected cases",
        "Partial (unicompartmental) knee replacement",
        "Total knee replacement",
        "Revision knee replacement"
      ],
      when_surgery: "Surgery is the best option when pain continues to limit your daily life despite proper conservative care — specifically when you find yourself avoiding stairs, waking up at night due to pain, or planning your entire day around the limitations of your knee. At that stage, a joint replacement reliably removes the worn surfaces, and most patients are able to walk on their new joint within just one day of surgery.",
      faq: [
        { q: "How long does a knee replacement last?",
          a: "Modern implants typically last 20–25 years or more for most patients, thanks to significant advancements in materials and fixation techniques over the last decade." },
        { q: "How soon will I walk after surgery?",
          a: "Most patients stand and take their first steps within 24 hours, begin walking with support within a few days, and achieve independent walking within 4–6 weeks." },
        { q: "Am I too young (or too old) for a replacement?",
          a: "There is no fixed age limit for the procedure. The decision is based on your symptoms, the extent of joint damage, and your overall health — not just your age." }
      ]
    ),
    new(
      slug: "hip", num: "02", crumb: "HIP OSTEOARTHRITIS", title: "Hip Osteoarthritis",
      image: "/images/cond-hip.webp",
      overview: "Hip osteoarthritis is the wearing away of the smooth cartilage of the ball-and-socket hip joint. It typically shows up as groin pain and stiffness — and because the hip carries your whole body, it can quietly shrink your world before you notice.",
      symptoms: [
        "Persistent pain in the groin, thigh, or buttock, especially during movement",
        "Noticeable stiffness when performing daily tasks like putting on shoes or socks",
        "A limp that becomes more pronounced as your day progresses",
        "Disrupted sleep due to persistent night pain",
        "A gradual, month-to-month decline in your walking capacity"
      ],
      conservative: [
        "Activity modification and weight management",
        "Physiotherapy and hip strengthening",
        "Anti-inflammatory medication",
        "Walking aids to offload the joint"
      ],
      surgical: [
        "Total hip replacement — modern bearing surfaces",
        "Minimally invasive approaches where suitable",
        "Rapid-recovery (same-week mobilization) protocols",
        "Revision hip replacement"
      ],
      when_surgery: "When groin pain disrupts your sleep, your limp becomes a constant challenge, or your walking distance continues to decline despite conservative care — hip replacement stands out as one of the most successful surgical procedures available today. You can typically expect profound and rapid pain relief.",
      faq: [
        { q: "How long is the hospital stay?",
          a: "Typically, patients stay for 1–3 nights. Most are able to stand either on the day of surgery or the following morning." },
        { q: "Will my legs be the same length after?",
          a: "Restoring both leg length and offset is a fundamental aspect of my surgical planning; precise pre-operative templating makes any significant leg length discrepancy extremely rare." },
        { q: "When can I drive again?",
          a: "Usually, you may return to driving after 4–6 weeks, once you have discontinued strong painkillers and can comfortably perform an emergency stop." }
      ]
    ),
    new(
      slug: "trauma", num: "03", crumb: "FRACTURES & TRAUMA", title: "Fractures & Trauma",
      image: "/images/cond-trauma.webp",
      overview: "Fractures resulting from falls, sports, or road accidents can vary from simple breaks to complex, multi-fragment injuries, particularly around the hip and knee joints. The initial fixation is the most critical step — when performed correctly, it establishes a solid foundation for your entire recovery journey.",
      symptoms: [
        "Inability to bear weight on the limb following an injury",
        "Visible deformity or noticeable shortening of the affected limb",
        "Severe swelling and extensive bruising",
        "Pain that intensifies rather than subsiding after several days",
        "A previous fracture showing signs of failing to heal (non-union)"
      ],
      conservative: [
        "Casting or bracing for stable, well-aligned fractures",
        "Close radiographic follow-up",
        "Early protected weight-bearing when safe",
        "Bone-health assessment and treatment"
      ],
      surgical: [
        "Internal fixation — plates, screws, and nails",
        "Fracture care around existing implants",
        "Staged reconstruction of complex injuries",
        "Treatment of non-union and malunion"
      ],
      when_surgery: "Surgery becomes the preferred option when a fracture is displaced or unstable, or when it involves a joint surface. It is also essential when early mobility is a priority — as is almost always the case with hip injuries. Modern fixation techniques allow us to mobilize patients early, which serves as the single most effective protection against potential complications.",
      faq: [
        { q: "How long does a fracture take to heal?",
          a: "Most fractures typically heal within 6–12 weeks, though regaining full function requires more time. Factors such as age, bone quality, and the specific fracture pattern all play a role." },
        { q: "Will the metal need to be removed?",
          a: "In most cases, this is unnecessary. Implants are only removed if they cause persistent symptoms or interfere with a future medical procedure." },
        { q: "I broke my hip — why is everyone rushing?",
          a: "Adult hip fractures require urgent treatment because early surgical intervention and rapid mobilization (walking) are critical to dramatically reducing potential complications." }
      ]
    ),
    new(
      slug: "complex", num: "04", crumb: "COMPLEX HIP CASES", title: "Complex Hip Cases",
      image: "/images/cond-complex.webp",
      overview: "Some hips are anatomically different from birth or have been significantly altered by disease. Developmental dysplasia of the hip (DDH) results in a shallow socket that leads to premature wear, while sickle-cell disease can compromise blood supply to the femoral head. Such cases require a surgeon who carefully plans around the unusual anatomy — rather than merely operating through it.",
      symptoms: [
        "Hip pain beginning at an unusually young age (20s–40s)",
        "A history of childhood hip conditions or previous brace treatment",
        "Sickle-cell disease accompanied by new onset of groin or hip pain",
        "A persistent, deep ache following periods of standing or walking",
        "A progressively worsening limp or a noticeable difference in leg length"
      ],
      conservative: [
        "Targeted physiotherapy and activity guidance",
        "Pain management and disease-specific care",
        "Coordination with hematology for sickle-cell patients",
        "Monitoring with periodic imaging"
      ],
      surgical: [
        "Total hip replacement adapted to dysplastic anatomy",
        "Reconstruction for avascular necrosis (AVN)",
        "Custom planning — 3D templating of the socket",
        "Revision of previous childhood surgery"
      ],
      when_surgery: "In cases of DDH and sickle-cell hip disease, surgical timing is a matter of strategy: operating too early can compromise the implant's lifespan, while delaying too long causes the bone stock to deteriorate. The optimal time is when pain significantly limits your daily life and imaging confirms disease progression — at this point, a carefully planned reconstruction can restore the function that your anatomy never naturally provided.",
      faq: [
        { q: "Is hip replacement harder with DDH?",
          a: "It requires more extensive planning, as the socket is typically shallow and the femur is often small; however, in experienced hands, surgical outcomes are excellent." },
        { q: "I have sickle-cell disease. Is surgery safe for me?",
          a: "Yes, it is safe with the right preparation. We coordinate closely with the hematology team before, during, and after surgery to manage the condition safely." },
        { q: "Can AVN be treated without a replacement?",
          a: "In the early stages, it is sometimes possible; a procedure called core decompression can be helpful. However, once the femoral head has collapsed, hip replacement becomes the most reliable solution." }
      ]
    )
  ].freeze
end
