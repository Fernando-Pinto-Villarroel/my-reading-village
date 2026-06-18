import { motion } from "framer-motion";
import { TrendingUp, DollarSign } from "lucide-react";

const years = [
  {
    year: "Año 1",
    mau: "1.000",
    revenue: "~USD 1.800",
    costs: "~USD 5.015",
    net: "~ –USD 3.215",
    netColor: "#E8637A",
    netBg: "#FFB3BA22",
  },
  {
    year: "Año 2",
    mau: "10.000",
    revenue: "~USD 18.000",
    costs: "~USD 9.990",
    net: "~ +USD 8.010",
    netColor: "#2E9E6B",
    netBg: "#B3FFD922",
  },
  {
    year: "Año 3",
    mau: "22.000",
    revenue: "~USD 28.000",
    costs: "~USD 12.200",
    net: "~ +USD 19.800",
    netColor: "#2E9E6B",
    netBg: "#B3FFD933",
  },
];

const FinancialsSlide = () => (
  <div className="relative w-full h-full flex flex-col items-center justify-center px-[5vw] z-10">
    <motion.h2
      initial={{ y: -20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      className="text-[2.8vw] font-black text-das-text mb-[0.5vh] text-center"
    >
      Proyecciones a 3 años y{" "}
      <span className="text-das-primary">Funding Ask</span>
    </motion.h2>
    <motion.p
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ delay: 0.15 }}
      className="text-[1.15vw] text-das-text/55 mb-[2.5vh] text-center"
    >
      Conservadoras a propósito. Prefiero quedarme corto y cumplir.
    </motion.p>

    <motion.div
      initial={{ y: 20, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.25 }}
      className="w-full bg-white/70 backdrop-blur-sm rounded-3xl overflow-hidden border border-das-light shadow-md mb-[2vh]"
    >
      <table className="w-full">
        <thead>
          <tr className="border-b border-das-light bg-das-light/30">
            <th className="text-left px-[2vw] py-[1.3vh] text-[1.2vw] text-das-text/60 font-semibold">
              Métrica
            </th>
            {years.map((y) => (
              <th
                key={y.year}
                className="text-center px-[1vw] py-[1.3vh] text-[1.05vw] font-black text-das-text"
              >
                {y.year}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {[
            { label: "MAU", key: "mau", color: "#7B79E8" },
            { label: "Ingresos", key: "revenue", color: "#2E9E6B" },
            { label: "Gastos", key: "costs", color: "#E8637A" },
          ].map((row) => (
            <tr key={row.label} className="border-b border-das-light/50">
              <td className="px-[2vw] py-[1.1vh] text-[1.2vw] font-semibold text-das-text/65">
                {row.label}
              </td>
              {years.map((y) => (
                <td
                  key={y.year}
                  className="text-center px-[1vw] py-[1.1vh] text-[1.05vw] font-bold"
                  style={{ color: row.color }}
                >
                  {y[row.key]}
                </td>
              ))}
            </tr>
          ))}
          <tr>
            <td className="px-[2vw] py-[1.1vh] text-[1.2vw] font-black text-das-text">
              Ingreso Neto
            </td>
            {years.map((y) => (
              <td
                key={y.year}
                className="text-center px-[1vw] py-[1.1vh] text-[1.05vw] font-black"
                style={{ color: y.netColor, backgroundColor: y.netBg }}
              >
                {y.net}
              </td>
            ))}
          </tr>
        </tbody>
      </table>
    </motion.div>

    <div className="flex gap-[2vw] w-full">
      <motion.div
        initial={{ x: -15, opacity: 0 }}
        animate={{ x: 0, opacity: 1 }}
        transition={{ delay: 0.5 }}
        className="flex-1 bg-das-primary/10 border-2 border-das-primary/40 rounded-3xl p-[1.8vw]"
      >
        <div className="flex items-center gap-[0.5vw] mb-[0.8vh]">
          <DollarSign className="w-[1.4vw] h-[1.4vw] text-das-primary" />
          <h3 className="text-[1.3vw] font-black text-das-primary">
            Funding Ask
          </h3>
        </div>
        <p className="text-[1.7vw] font-black text-das-text mb-[0.4vh]">
          USD 10K - 30K
        </p>
        <p className="text-[1.15vw] text-das-text/80">
          Ronda semilla opcional (ángel / concurso). Solo con métricas
          validadas: 1.000+ MAU y ROI mensual positivo.
        </p>
        <div className="flex gap-[0.5vw] mt-[1vh] flex-wrap">
          {["Dev & contenido", "Marketing ASO", "Ops & soporte"].map((b) => (
            <span
              key={b}
              className="text-[0.95vw] bg-das-primary/15 text-das-primary px-[0.7vw] py-[0.25vh] rounded-full font-semibold"
            >
              {b}
            </span>
          ))}
        </div>
      </motion.div>

      <motion.div
        initial={{ x: 15, opacity: 0 }}
        animate={{ x: 0, opacity: 1 }}
        transition={{ delay: 0.6 }}
        className="flex-1 bg-das-mint/30 border border-das-mint rounded-3xl p-[1.8vw]"
      >
        <div className="flex items-center gap-[0.5vw] mb-[0.8vh]">
          <TrendingUp className="w-[1.4vw] h-[1.4vw] text-green-700" />
          <h3 className="text-[1.2vw] font-black text-green-700">
            Break-even Mensual
          </h3>
        </div>
        <p className="text-[1.6vw] font-black text-das-text mb-[0.4vh]">
          ~Mes 15
        </p>
        <p className="text-[1.05vw] text-das-text/80">
          Sin costo de servidor → costo marginal casi cero por usuario
          adicional. Casi todo ingreso por encima de costos fijos es margen.
        </p>
        <p className="text-[1.1vw] text-das-text/80 mt-[1vh]">
          Supuestos: ARPU ~USD 0.30 escalando levemente - conversión 2–3% - sin
          backend
        </p>
      </motion.div>
    </div>
  </div>
);

export default FinancialsSlide;
