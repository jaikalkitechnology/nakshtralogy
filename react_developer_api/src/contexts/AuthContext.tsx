import { createContext, useContext, useState, useEffect, type ReactNode } from "react";
import {
  loginDeveloper, logoutDeveloper, getStoredDeveloper, getMe, type DeveloperUser,
} from "@/lib/api";

interface AuthContextType {
  developer: DeveloperUser | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<{ error: string | null }>;
  logout: () => void;
  refresh: () => Promise<void>;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | null>(null);

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
};

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [developer, setDeveloper] = useState<DeveloperUser | null>(null);
  const [loading, setLoading] = useState(true);

  const refresh = async () => {
    const { ok, data } = await getMe();
    if (ok) {
      setDeveloper(data);
      localStorage.setItem("developer_user", JSON.stringify(data));
    }
  };

  useEffect(() => {
    const stored = getStoredDeveloper();
    if (stored) {
      setDeveloper(stored);
      refresh().finally(() => setLoading(false));
    } else {
      setLoading(false);
    }
  }, []);

  const login = async (email: string, password: string) => {
    const { ok, data } = await loginDeveloper(email, password);
    if (ok && data.user) {
      setDeveloper(data.user);
      return { error: null };
    }
    return { error: data.detail || "Login failed" };
  };

  const logout = () => {
    logoutDeveloper();
    setDeveloper(null);
  };

  return (
    <AuthContext.Provider value={{ developer, loading, login, logout, refresh, isAuthenticated: !!developer }}>
      {children}
    </AuthContext.Provider>
  );
};
