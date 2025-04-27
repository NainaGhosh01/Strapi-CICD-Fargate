import { mergeConfig, type UserConfig } from 'vite';

export default (config: UserConfig) => {
  return mergeConfig(config, {
    server: {
      allowedHosts: [
        // Allow all ALB hosts (wildcard)
        '.elb.amazonaws.com',  // This will allow any hostname ending with 'elb.amazonaws.com'
      ],
    },
  });
};
