import React, { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { loginAdmin as apiLogin, logoutAdmin as apiLogout, getStoredUser } from "@/services/api";

export type UserRole = "user" | "astrologer" | "admin";

interface AuthUser {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  avatar?: string;
  walletBalance: number;
}

interface AuthContextType {
  user: AuthUser | null;
  loading: boolean;
  login: (email: string, password: string, role: UserRole) => Promise<string | null>;
  signup: (name: string, email: string, password: string, role: UserRole) => void;
  logout: () => void;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | null>(null);

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be within AuthProvider");
  return ctx;
};

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<AuthUser | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const stored = getStoredUser();
    if (stored) {
      setUser({
        id: stored.id,
        name: stored.name || "Admin",
        email: stored.email,
        role: stored.role,
        walletBalance: stored.wallet_balance || 0,
      });
    }
    setLoading(false);
  }, []);

  const login = async (email: string, password: string, _role: UserRole): Promise<string | null> => {
    const { ok, data } = await apiLogin(email, password);
    if (ok && data.user) {
      const u = data.user;
      if (u.role !== "admin") {
        apiLogout();
        return "Only admin accounts can access this panel";
      }
      setUser({
        id: u.id,
        name: u.name || "Admin",
        email: u.email,
        role: u.role,
        walletBalance: u.wallet_balance || 0,
      });
      return null;
    }
    return data.detail || "Login failed";
  };

  const signup = (_name: string, _email: string, _password: string, _role: UserRole) => {
    // Admin signup not supported from panel
  };

  const logout = () => {
    apiLogout();
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, signup, logout, isAuthenticated: !!user }}>
      {children}
    </AuthContext.Provider>
  );
};
