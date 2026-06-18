import { motion } from "framer-motion";

export const SlideLoader = () => {
  return (
    <motion.div
      data-testid="slide-loading-spinner"
      initial={{ opacity: 0, scale: 0.9 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 0.9 }}
      transition={{ duration: 0.3 }}
      className="flex flex-col items-center justify-center gap-6 h-full w-full"
    >
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
        className="flex flex-col items-center gap-3"
      >
        <div className="relative">
          <motion.div
            className="w-12 h-12 border-4 border-das-body border-t-das-shadow rounded-full"
            animate={{ rotate: 360 }}
            transition={{
              duration: 1,
              repeat: Infinity,
              ease: "linear",
            }}
          />
          <motion.div
            className="absolute inset-0 w-12 h-12 border-4 border-transparent border-t-das-text rounded-full"
            animate={{ rotate: -360 }}
            transition={{
              duration: 1.5,
              repeat: Infinity,
              ease: "linear",
            }}
          />
        </div>
        <h3 className="text-xl font-bold text-white bg-gradient-to-r from-das-shadow to-das-body bg-clip-text text-transparent">
          Loading slide
        </h3>
        <p className="text-sm text-gray-300">
          Please wait while we load the content
        </p>
      </motion.div>

      <motion.div
        className="flex gap-1"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.4 }}
      >
        {[0, 1, 2, 3, 4].map((i) => (
          <motion.div
            key={i}
            className="w-1.5 h-1.5 bg-gradient-to-r from-das-shadow to-das-body rounded-full"
            animate={{
              scale: [1, 1.5, 1],
              opacity: [0.5, 1, 0.5],
            }}
            transition={{
              duration: 1.2,
              repeat: Infinity,
              delay: i * 0.1,
            }}
          />
        ))}
      </motion.div>
    </motion.div>
  );
};
